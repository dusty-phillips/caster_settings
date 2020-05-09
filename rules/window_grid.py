from dragonfly import Function, Repeat, Dictation, Choice, MappingRule

from castervoice.lib.actions import Key, Mouse
from castervoice.lib import navigation, utilities
from castervoice.rules.core.navigation_rules import navigation_support

try:  # Try first loading from caster user directory
    from alphabet_rules import alphabet_support
except ImportError: 
    from castervoice.rules.core.alphabet_rules import alphabet_support

from castervoice.lib.ctrl.mgr.rule_details import RuleDetails
from castervoice.lib.merge.additions import IntegerRefST
from castervoice.lib.merge.state.actions import AsynchronousAction
from castervoice.lib.merge.state.short import S, L, R

# To be used with my Auto hotkeys configuration



class WindowGrid(MappingRule):

    pronunciation = "window grid"

    mapping = {
        # halfs
        "window <xy>":
            R(Key("wca-g,h")),
    }

    extras = [
        Choice("xy", {
            "top left": "g"
        }),
        Choice("wh", {
            "1/3 x 1/3": "7"
        })
    ]
    defaults = {
        "wh": "h", # 1/2 x 1/12
    }

def get_rule():
    return WindowGrid, RuleDetails(name="window grid")
