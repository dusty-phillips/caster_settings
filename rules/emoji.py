# coding=utf8

from dragonfly import MappingRule, Choice, Function

from castervoice.lib.const import CCRType
from castervoice.lib.actions import Text, Key
from castervoice.lib.ctrl.mgr.rule_details import RuleDetails
from castervoice.lib.merge.state.short import R
from castervoice.lib.merge.mergerule import MergeRule
from castervoice.lib.context import paste_string_without_altering_clipboard


words = {
    "smile": "☺️",
    "wink": "😉",
    "heart eyes": "😍",
    "grin": "😀",
    "joy": "😂",
    "ruffle": "🤣",
    "sad": "😟",
    "sob": "😭",
    "cry": "😢",
    "thumbs up": "👍",
    "thumbs down": "👎",
    "poop": "💩",
    "snowman": "⛄",
}


def paste_it(word):
    print(word)
    paste_string_without_altering_clipboard(words[word])


class Emoji(MergeRule):
    pronunciation = "emoji"
    mapping = {"<word> icon": R(Function(paste_it)), "emoji keyboard": R(Key("w-."))}

    extras = [Choice("word", {k: k for k in words})]


def get_rule():
    return Emoji, RuleDetails(ccrtype=CCRType.GLOBAL)
