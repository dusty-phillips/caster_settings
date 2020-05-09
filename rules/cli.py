from dragonfly import MappingRule, Choice

from castervoice.lib.const import CCRType
from castervoice.lib.actions import Text, Key
from castervoice.lib.ctrl.mgr.rule_details import RuleDetails
from castervoice.lib.merge.state.short import R
from castervoice.lib.merge.mergerule import MergeRule



class CLI(MergeRule):
    pronunciation = "CLI"
    mapping = {
        "giddy": R(Text("git ")),
        "CD": R(Text("cd ")),
        "parent": R(Text("../")),
        "list files": R(Text("ls ")),
        "move file": R(Text("mv ")),
        "copy file": R(Text("cp ")),
        "remove file": R(Text("rm ")),
        "make directory": R(Text("mkdir ")),
        "NPM": R(Text("npm ")),
        "neon release": R(Text("neon build --release")),
        "cargo build release": R(Text("cargo build --release")),
        "cargo test release": R(Text("cargo test --release")),
        "cargo run release": R(Text("cargo run --release")),
        "cargo format": R(Text("cargo fmt")),
        "pseudo-": R(Text("sudo ")),
        " enough": R(Text("dnf ")),

        "previous command": R(Key("c-p")),
        "exit shall": R(Key("c-d")),
        "interrupt": R(Key("c-c")),
    }



def get_rule():
    return CLI, RuleDetails(
                               executable="code",
                          title="Visual Studio Code",
                          ccrtype=CCRType.APP)
