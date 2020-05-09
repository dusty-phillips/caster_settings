from dragonfly import MappingRule, Choice

from castervoice.lib.const import CCRType
from castervoice.lib.actions import Text, Key
from castervoice.lib.ctrl.mgr.rule_details import RuleDetails
from castervoice.lib.merge.state.short import R
from castervoice.lib.merge.mergerule import MergeRule


class TrickyWords(MergeRule):
    pronunciation = "tricky words"
    mapping = {
        "fix <word>": R(Text("%(word)s")),
    }
    extras = [
        Choice(
            "word",
            {
                "at": "add",
                "rest": "rust",
                "note": "node",
                "bite": "byte",
                "bites": "bytes",
                "right": "write",
                "sink": "sync",
                "cash": "cache",
                "oh eight": "await",
                "while it": "wallet",
                "Mark ": "mock",
            },
        )
    ]


def get_rule():
    return TrickyWords, RuleDetails(ccrtype=CCRType.GLOBAL)
