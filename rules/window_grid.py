from dragonfly import Function, Repeat, Dictation, Choice, MappingRule, Pause

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
# most of these configurations should be pretty straightforward
# For the window <n1> by <n2>, imagine the screen split into
# 9 equal pieces:
#
#  1 2 3
#  4 5 6
#  7 8 9
#
# "window 4 by 8" would cover the lower left two thirds of the screen
# like this:
#
# o o o
# x x o
# x x o


class WindowGrid(MappingRule):

    pronunciation = "window grid"

    mapping = {
        # quarter corners
        "window (top|upper) left": R(Key("wa-g")),
        "window (top|upper) right": R(Key("wa-r")),
        "window (bottom|lower) left": R(Key("wa-m")),
        "window (bottom|lower) right": R(Key("wa-v")),
        # halves
        "window (top|upper) [half]": R(Key("wa-c")),
        "window (bottom|lower) [half]": R(Key("wa-w")),
        "window middle half": R(Key("wa-t")),
        "window left [half]": R(Key("wa-h")),
        "window right [half]": R(Key("wa-n")),
        # sixths
        "window (top|upper) left third": R(Key("cwa-g")),
        "window (top|upper) right third": R(Key("cwa-r")),
        "window middle left third": R(Key("cwa-h")),
        "window middle right third": R(Key("cwa-n")),
        "window (bottom|lower) left third": R(Key("cwa-m")),
        "window (bottom|lower) right third": R(Key("cwa-v")),
        # horizontal thirds
        "window (top|upper) third": R(Key("cwa-c")),
        "window middle third": R(Key("cwa-t")),
        "window (bottom|lower) third": R(Key("cwa-w")),
        # horizontal two thirds
        "window (top|upper) two thirds": R(Key("wc-g") + Pause("20") + Key("n")),
        "window (bottom|lower) two thirds": R(Key("wc-h") + Pause("20") + Key("v")),
        # grid size
        "window <n1> by <n2>": R(Key("wc-%(n1)s") + Pause("20") + Key("%(n2)s")),
    }

    extras = [
        Choice(
            "n1",
            {
                "one": "g",
                "two": "c",
                "three": "r",
                "four": "h",
                "five": "t",
                "six": "n",
                "seven": "m",
                "eight": "w",
                "nine": "v",
            },
        ),
        Choice(
            "n2",
            {
                "one": "g",
                "two": "c",
                "three": "r",
                "four": "h",
                "five": "t",
                "six": "n",
                "seven": "m",
                "eight": "w",
                "nine": "v",
            },
        ),
    ]
    defaults = {}


def get_rule():
    return WindowGrid, RuleDetails(name="window grid")
