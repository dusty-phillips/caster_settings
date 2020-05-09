from dragonfly import MappingRule, Choice, Pause

from castervoice.lib.const import CCRType
from castervoice.lib.actions import Text, Key
from castervoice.lib.ctrl.mgr.rule_details import RuleDetails
from castervoice.lib.merge.state.short import R
from castervoice.lib.merge.mergerule import MergeRule



class Roar(MappingRule):
    pronunciation = "roar"
    mapping = {
        "roar": R(Key("c-a") + Key("c-c") + Key("a-f4") + Key("tab") + Key("enter") + Pause("100") + Key("c-v")),
    }
    


def get_rule():
    return Roar, RuleDetails(name="roar")
