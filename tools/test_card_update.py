#!/usr/bin/env python3
"""card_update.py の判定の組み立てを確かめる。ネットワークにも Claude にも触れない。

  python3 tools/test_card_update.py
"""
import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import card_update  # noqa: E402
from card_update import UpdateFailed  # noqa: E402
from geo_utils import geopoint  # noqa: E402

OLD_POINT = geopoint(35.0, 139.0)
NEW_POINT = geopoint(36.0, 140.0)


def make_card(**overrides):
    card = {
        "image_url": "https://www.gk-p.jp/uploads/mhc/13-100-R101.jpg",
        "municipality": "中野区",
        "serial": "R101",
        "edition": "第20弾",
        "issued_date": "2024/01/01",
        "distribution_place_html": "<p>区役所</p>",
        "distribution_time_html": "<p>平日</p>",
        "stock_html": '<a href="https://city.example/card">こちらからご確認ください</a>',
        "stock_text": "こちらからご確認ください",
        "addresses": ["東京都中野区1-1"],
        "points": [OLD_POINT],
        "state": "distributing",
    }
    card.update(overrides)
    return card


def make_row(**overrides):
    row = {
        "image_url": "https://www.gk-p.jp/uploads/mhc/13-100-R101.jpg",
        "prefecture": "東京都",
        "distribution_html": "<p>区役所</p>",
        "distribution_time_html": "<p>平日</p>",
        "stock_html": '<a href="https://city.example/card">こちらからご確認ください</a>',
        "stock_text": "こちらからご確認ください",
    }
    row.update(overrides)
    return row


def make_state(**card_overrides):
    return {"cards": {"13-100-R101": make_card(**card_overrides)}, "pages": {}}


def no_save(_state):
    pass


def not_asked(_prompt):
    raise AssertionError("Claude に尋ねないはず")


def not_geocoded(_addresses):
    raise AssertionError("座標を取らないはず")


def row_reply(state="distributing", addresses=("東京都中野区1-1",)):
    return {"results": {"13-100-R101": {"state": state, "addresses": list(addresses)}}}


def page_reply(state):
    return {"results": [{"page_id": "p01", "card_id": "13-100-R101", "state": state}]}


def make_page(text="本文"):
    return {"url": "https://city.example/card", "card_ids": ["13-100-R101"], "text": text}


class ApplyRowsTest(unittest.TestCase):
    def apply(self, state, row, ask=not_asked, geocode=not_geocoded):
        card_update.apply_rows(state, [row], ask, geocode, no_save)
        return state["cards"]["13-100-R101"]

    def test_変わっていなければ読まない(self):
        card = self.apply(make_state(), make_row())
        self.assertEqual(card["state"], "distributing")

    def test_配布時間は読まずに反映する(self):
        card = self.apply(make_state(), make_row(distribution_time_html="<p>土日</p>"))
        self.assertEqual(card["distribution_time_html"], "<p>土日</p>")

    def test_文言の同じリンクの変更は読まずに反映する(self):
        html = '<a href="https://city.example/new">こちらからご確認ください</a>'
        card = self.apply(make_state(), make_row(stock_html=html))
        self.assertEqual(card["stock_html"], html)

    def test_在庫の文言が変わったら配布状態を読み直す(self):
        card = self.apply(make_state(), make_row(stock_text="配布終了"),
                          ask=lambda _: row_reply("stopped"))
        self.assertEqual(card["state"], "stopped")
        self.assertEqual(card["stock_text"], "配布終了")

    def test_配布場所だけ変わったら配布状態は変えない(self):
        card = self.apply(make_state(), make_row(distribution_html="<p>図書館</p>"),
                          ask=lambda _: row_reply("stopped"))
        self.assertEqual(card["state"], "distributing")
        self.assertEqual(card["distribution_place_html"], "<p>図書館</p>")

    def test_住所が同じなら座標を取らない(self):
        card = self.apply(make_state(), make_row(distribution_html="<p>区役所 本館</p>"),
                          ask=lambda _: row_reply())
        self.assertEqual(card["points"], [OLD_POINT])

    def test_住所が変わったら座標を取り直す(self):
        card = self.apply(make_state(), make_row(distribution_html="<p>図書館</p>"),
                          ask=lambda _: row_reply(addresses=["東京都中野区2-2"]),
                          geocode=lambda _: [NEW_POINT])
        self.assertEqual(card["addresses"], ["東京都中野区2-2"])
        self.assertEqual(card["points"], [NEW_POINT])

    def test_座標に変換できなければ住所も座標も変えない(self):
        card = self.apply(make_state(), make_row(distribution_html="<p>図書館</p>"),
                          ask=lambda _: row_reply(addresses=["東京都中野区2-2"]),
                          geocode=lambda _: None)
        self.assertEqual(card["addresses"], ["東京都中野区1-1"])
        self.assertEqual(card["points"], [OLD_POINT])

    def test_蓋の位置に関わる値は持たない(self):
        self.assertNotIn("location", card_update.current_values(make_card()))

    def test_masterにないカードは無視する(self):
        state = make_state()
        card_update.apply_rows(state, [make_row(image_url="https://other", stock_text="配布終了")],
                               not_asked, not_geocoded, no_save)
        self.assertEqual(state["cards"]["13-100-R101"]["stock_text"], "こちらからご確認ください")

    def test_返答の形が違えば失敗にして値を変えない(self):
        state = make_state()
        for reply in ({}, {"results": {}}, {"results": {"13-100-R101": {"state": "?", "addresses": []}}}):
            with self.assertRaises(UpdateFailed):
                card_update.apply_rows(state, [make_row(stock_text="配布終了")],
                                       lambda _, r=reply: r, not_geocoded, no_save)
        self.assertEqual(state["cards"]["13-100-R101"]["stock_text"], "こちらからご確認ください")


class ApplyPagesTest(unittest.TestCase):
    def apply(self, state, reply, pages=None):
        card_update.apply_pages(state, pages or [make_page()], lambda _: reply, no_save, "2026-11-01")
        return state["cards"]["13-100-R101"]

    def test_明確な記述は配布状態に当てて記録する(self):
        state = make_state()
        self.assertEqual(self.apply(state, page_reply("stopped"))["state"], "stopped")
        self.assertEqual(state["pages"]["https://city.example/card"]["hash"], card_update.hash_of("本文"))

    def test_再開の記述で配布中に戻す(self):
        self.assertEqual(self.apply(make_state(state="stopped"), page_reply("distributing"))["state"],
                         "distributing")

    def test_記述がなければ変えないが読んだ記録は残す(self):
        for verdict in ("no_statement", "unclear"):
            state = make_state(state="notClear")
            self.assertEqual(self.apply(state, page_reply(verdict))["state"], "notClear")
            self.assertIn("https://city.example/card", state["pages"])

    def test_判定が欠けていれば失敗にして読んだ記録を残さない(self):
        state = make_state()
        with self.assertRaises(UpdateFailed):
            self.apply(state, {"results": []})
        self.assertEqual(state["pages"], {})

    def test_知らない判定は失敗にする(self):
        with self.assertRaises(UpdateFailed):
            self.apply(make_state(), page_reply("maybe"))


class ConflictTest(unittest.TestCase):
    def test_同じ回なら自治体の記述を優先する(self):
        state = make_state()
        card_update.apply_rows(state, [make_row(stock_text="配布終了")],
                               lambda _: row_reply("stopped"), not_geocoded, no_save)
        card_update.apply_pages(state, [make_page()], lambda _: page_reply("distributing"), no_save, "2026-11-01")
        self.assertEqual(state["cards"]["13-100-R101"]["state"], "distributing")

    def test_回が違えば後から変わったgkpを採用する(self):
        state = make_state()
        card_update.apply_pages(state, [make_page()], lambda _: page_reply("stopped"), no_save, "2026-11-01")
        self.assertEqual(state["cards"]["13-100-R101"]["state"], "stopped")
        card_update.apply_rows(state, [make_row(stock_text="配布を再開しました")],
                               lambda _: row_reply("distributing"), not_geocoded, no_save)
        # 自治体のページは変わっていないので読み直さない。
        self.assertEqual(card_update.changed_pages(state, {"https://city.example/card": "本文"}), [])
        self.assertEqual(state["cards"]["13-100-R101"]["state"], "distributing")


class ChangedPagesTest(unittest.TestCase):
    def test_初めてのページと本文が変わったページを読む(self):
        state = make_state()
        self.assertEqual(len(card_update.changed_pages(state, {"https://city.example/card": "本文"})), 1)
        state["pages"]["https://city.example/card"] = {"hash": card_update.hash_of("本文"), "read_at": ""}
        self.assertEqual(card_update.changed_pages(state, {"https://city.example/card": "本文"}), [])
        self.assertEqual(len(card_update.changed_pages(state, {"https://city.example/card": "新しい本文"})), 1)

    def test_読めなかったページは読まない(self):
        self.assertEqual(card_update.changed_pages(make_state(), {}), [])

    def test_1ページを複数のカードが指す(self):
        cards = {"A": make_card(), "B": make_card()}
        self.assertEqual(card_update.pages_of(cards), {"https://city.example/card": ["A", "B"]})


class BuildUpdatesTest(unittest.TestCase):
    def master_card(self, **overrides):
        card = {
            "id": "13-100-R101",
            "location": geopoint(35.5, 139.5),
            "distribution_place_html": "<p>区役所</p>",
            "distribution_time_html": "<p>平日</p>",
            "stock_html": make_card()["stock_html"],
            "distribution_points": [OLD_POINT],
            "distribution_state": "distributing",
        }
        card.update(overrides)
        return card

    def test_masterと同じなら差分にしない(self):
        self.assertEqual(card_update.build_updates([self.master_card()], {"13-100-R101": make_card()}), [])

    def test_違えば5項目をまとめて載せる(self):
        updates = card_update.build_updates([self.master_card()], {"13-100-R101": make_card(state="stopped")})
        self.assertEqual(updates, [{
            "id": "13-100-R101",
            "distribution_place_html": "<p>区役所</p>",
            "distribution_time_html": "<p>平日</p>",
            "stock_html": make_card()["stock_html"],
            "distribution_state": "stopped",
            "distribution_points": [OLD_POINT],
        }])

    def test_記録にないカードは差分にしない(self):
        self.assertEqual(card_update.build_updates([self.master_card(id="Z")], {"13-100-R101": make_card()}), [])


class ParseTest(unittest.TestCase):
    def test_返答の前後の文を除いてJSONを読む(self):
        self.assertEqual(card_update.parse_reply('結果です\n```json\n{"a": 1}\n```'), {"a": 1})

    def test_JSONがなければ失敗にする(self):
        for text in ("", None, "ありません", "{壊れた}"):
            with self.assertRaises(UpdateFailed):
                card_update.parse_reply(text)

    def test_在庫欄のリンクはhttpだけを重複なく取る(self):
        html = ('<a href="https://a.example/x">1</a><a href=\'http://b.example\'>2</a>'
                '<a href="https://a.example/x">3</a><a href="mailto:a@example.com">4</a>')
        self.assertEqual(card_update.urls_of(html), ["https://a.example/x", "http://b.example"])

    def test_本文はスクリプトと空白を除く(self):
        self.assertEqual(card_update.text_of("<script>x</script><p>在庫&amp;\n あり</p>"), "在庫& あり")


class BaselineStateTest(unittest.TestCase):
    def base(self, **overrides):
        card = {
            "card_id": "card_0001",
            "ocr_id": "13-100-R101",
            "image_url": "https://www.gk-p.jp/uploads/mhc/13-100-R101.jpg",
            "municipality": "中野区",
            "serial": "R101",
            "edition": "第20弾",
            "issued_date": "2024/01/01",
            "distribution_html": "<p>区役所</p>",
            "distribution_time_html": "<p>平日</p>",
            "stock_html": "",
            "stock_text": "",
            "dist_addresses": ["東京都中野区1-1", "東京都中野区9-9"],
            "dist_state": "notClear",
        }
        card.update(overrides)
        return card

    def test_使える座標だけをbuild_masterと同じ条件で取る(self):
        cache = {
            "東京都中野区1-1": {"status": "OK", "lat": 35.0, "lon": 139.0, "jp_ok": True},
            "東京都中野区9-9": {"status": "ZERO_RESULTS"},
        }
        state = card_update.new_state_from_cards_base([self.base()], cache)
        card = state["cards"]["13-100-R101"]
        self.assertEqual(card["points"], [OLD_POINT])
        self.assertEqual(card["state"], "notClear")
        self.assertTrue(state["baseline_in_progress"])

    def test_確定していないカードがあれば始めない(self):
        with self.assertRaises(UpdateFailed):
            card_update.new_state_from_cards_base([self.base(ocr_id="")], {})


if __name__ == "__main__":
    unittest.main()
