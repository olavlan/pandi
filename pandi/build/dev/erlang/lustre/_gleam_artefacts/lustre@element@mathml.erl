-module(lustre@element@mathml).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/lustre/element/mathml.gleam").
-export([merror/2, mphantom/2, mprescripts/2, mrow/2, mstyle/2, semantics/2, mmultiscripts/2, mover/2, msub/2, msubsup/2, msup/2, munder/2, munderover/2, mroot/2, msqrt/2, annotation/2, annotation_xml/2, mfrac/2, mn/2, mo/2, mi/2, mpadded/2, ms/2, mspace/1, mtable/2, mtd/2, mtext/2, mtr/2]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-file("src/lustre/element/mathml.gleam", 23).
?DOC("\n").
-spec merror(
    list(lustre@vdom@vattr:attribute(PBJ)),
    list(lustre@vdom@vnode:element(PBJ))
) -> lustre@vdom@vnode:element(PBJ).
merror(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"merror"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 31).
?DOC("\n").
-spec mphantom(
    list(lustre@vdom@vattr:attribute(PBP)),
    list(lustre@vdom@vnode:element(PBP))
) -> lustre@vdom@vnode:element(PBP).
mphantom(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mphantom"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 39).
?DOC("\n").
-spec mprescripts(
    list(lustre@vdom@vattr:attribute(PBV)),
    list(lustre@vdom@vnode:element(PBV))
) -> lustre@vdom@vnode:element(PBV).
mprescripts(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mprescripts"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 47).
?DOC("\n").
-spec mrow(
    list(lustre@vdom@vattr:attribute(PCB)),
    list(lustre@vdom@vnode:element(PCB))
) -> lustre@vdom@vnode:element(PCB).
mrow(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mrow"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 55).
?DOC("\n").
-spec mstyle(
    list(lustre@vdom@vattr:attribute(PCH)),
    list(lustre@vdom@vnode:element(PCH))
) -> lustre@vdom@vnode:element(PCH).
mstyle(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mstyle"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 63).
?DOC("\n").
-spec semantics(
    list(lustre@vdom@vattr:attribute(PCN)),
    list(lustre@vdom@vnode:element(PCN))
) -> lustre@vdom@vnode:element(PCN).
semantics(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"semantics"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 73).
?DOC("\n").
-spec mmultiscripts(
    list(lustre@vdom@vattr:attribute(PCT)),
    list(lustre@vdom@vnode:element(PCT))
) -> lustre@vdom@vnode:element(PCT).
mmultiscripts(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mmultiscripts"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 81).
?DOC("\n").
-spec mover(
    list(lustre@vdom@vattr:attribute(PCZ)),
    list(lustre@vdom@vnode:element(PCZ))
) -> lustre@vdom@vnode:element(PCZ).
mover(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mover"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 89).
?DOC("\n").
-spec msub(
    list(lustre@vdom@vattr:attribute(PDF)),
    list(lustre@vdom@vnode:element(PDF))
) -> lustre@vdom@vnode:element(PDF).
msub(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"msub"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 97).
?DOC("\n").
-spec msubsup(
    list(lustre@vdom@vattr:attribute(PDL)),
    list(lustre@vdom@vnode:element(PDL))
) -> lustre@vdom@vnode:element(PDL).
msubsup(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"msubsup"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 105).
?DOC("\n").
-spec msup(
    list(lustre@vdom@vattr:attribute(PDR)),
    list(lustre@vdom@vnode:element(PDR))
) -> lustre@vdom@vnode:element(PDR).
msup(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"msup"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 113).
?DOC("\n").
-spec munder(
    list(lustre@vdom@vattr:attribute(PDX)),
    list(lustre@vdom@vnode:element(PDX))
) -> lustre@vdom@vnode:element(PDX).
munder(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"munder"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 121).
?DOC("\n").
-spec munderover(
    list(lustre@vdom@vattr:attribute(PED)),
    list(lustre@vdom@vnode:element(PED))
) -> lustre@vdom@vnode:element(PED).
munderover(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"munderover"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 131).
?DOC("\n").
-spec mroot(
    list(lustre@vdom@vattr:attribute(PEJ)),
    list(lustre@vdom@vnode:element(PEJ))
) -> lustre@vdom@vnode:element(PEJ).
mroot(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mroot"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 139).
?DOC("\n").
-spec msqrt(
    list(lustre@vdom@vattr:attribute(PEP)),
    list(lustre@vdom@vnode:element(PEP))
) -> lustre@vdom@vnode:element(PEP).
msqrt(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"msqrt"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 149).
?DOC("\n").
-spec annotation(
    list(lustre@vdom@vattr:attribute(PEV)),
    list(lustre@vdom@vnode:element(PEV))
) -> lustre@vdom@vnode:element(PEV).
annotation(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"annotation"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 157).
?DOC("\n").
-spec annotation_xml(
    list(lustre@vdom@vattr:attribute(PFB)),
    list(lustre@vdom@vnode:element(PFB))
) -> lustre@vdom@vnode:element(PFB).
annotation_xml(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"annotation-xml"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 165).
?DOC("\n").
-spec mfrac(
    list(lustre@vdom@vattr:attribute(PFH)),
    list(lustre@vdom@vnode:element(PFH))
) -> lustre@vdom@vnode:element(PFH).
mfrac(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mfrac"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 173).
?DOC("\n").
-spec mn(list(lustre@vdom@vattr:attribute(PFN)), binary()) -> lustre@vdom@vnode:element(PFN).
mn(Attrs, Text) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mn"/utf8>>,
        Attrs,
        [lustre@element:text(Text)]
    ).

-file("src/lustre/element/mathml.gleam", 178).
?DOC("\n").
-spec mo(list(lustre@vdom@vattr:attribute(PFR)), binary()) -> lustre@vdom@vnode:element(PFR).
mo(Attrs, Text) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mo"/utf8>>,
        Attrs,
        [lustre@element:text(Text)]
    ).

-file("src/lustre/element/mathml.gleam", 183).
?DOC("\n").
-spec mi(list(lustre@vdom@vattr:attribute(PFV)), binary()) -> lustre@vdom@vnode:element(PFV).
mi(Attrs, Text) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mi"/utf8>>,
        Attrs,
        [lustre@element:text(Text)]
    ).

-file("src/lustre/element/mathml.gleam", 188).
?DOC("\n").
-spec mpadded(
    list(lustre@vdom@vattr:attribute(PFZ)),
    list(lustre@vdom@vnode:element(PFZ))
) -> lustre@vdom@vnode:element(PFZ).
mpadded(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mpadded"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 196).
?DOC("\n").
-spec ms(list(lustre@vdom@vattr:attribute(PGF)), binary()) -> lustre@vdom@vnode:element(PGF).
ms(Attrs, Text) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"ms"/utf8>>,
        Attrs,
        [lustre@element:text(Text)]
    ).

-file("src/lustre/element/mathml.gleam", 201).
?DOC("\n").
-spec mspace(list(lustre@vdom@vattr:attribute(PGJ))) -> lustre@vdom@vnode:element(PGJ).
mspace(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mspace"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/mathml.gleam", 206).
?DOC("\n").
-spec mtable(
    list(lustre@vdom@vattr:attribute(PGN)),
    list(lustre@vdom@vnode:element(PGN))
) -> lustre@vdom@vnode:element(PGN).
mtable(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mtable"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 214).
?DOC("\n").
-spec mtd(
    list(lustre@vdom@vattr:attribute(PGT)),
    list(lustre@vdom@vnode:element(PGT))
) -> lustre@vdom@vnode:element(PGT).
mtd(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mtd"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/mathml.gleam", 222).
?DOC("\n").
-spec mtext(list(lustre@vdom@vattr:attribute(PGZ)), binary()) -> lustre@vdom@vnode:element(PGZ).
mtext(Attrs, Text) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mtext"/utf8>>,
        Attrs,
        [lustre@element:text(Text)]
    ).

-file("src/lustre/element/mathml.gleam", 227).
?DOC("\n").
-spec mtr(
    list(lustre@vdom@vattr:attribute(PHD)),
    list(lustre@vdom@vnode:element(PHD))
) -> lustre@vdom@vnode:element(PHD).
mtr(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"mtr"/utf8>>,
        Attrs,
        Children
    ).
