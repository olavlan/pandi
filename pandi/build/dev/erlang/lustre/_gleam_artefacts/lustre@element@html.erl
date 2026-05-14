-module(lustre@element@html).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/lustre/element/html.gleam").
-export([html/2, text/1, base/1, head/2, link/1, meta/1, style/2, title/2, body/2, address/2, article/2, aside/2, footer/2, header/2, h1/2, h2/2, h3/2, h4/2, h5/2, h6/2, hgroup/2, main/2, nav/2, section/2, search/2, blockquote/2, dd/2, 'div'/2, dl/2, dt/2, figcaption/2, figure/2, hr/1, li/2, menu/2, ol/2, p/2, pre/2, ul/2, a/2, abbr/2, b/2, bdi/2, bdo/2, br/1, cite/2, code/2, data/2, dfn/2, em/2, i/2, kbd/2, mark/2, q/2, rp/2, rt/2, ruby/2, s/2, samp/2, small/2, span/2, strong/2, sub/2, sup/2, time/2, u/2, var/2, wbr/1, area/1, audio/2, img/1, map/2, track/1, video/2, embed/1, iframe/1, object/1, picture/2, portal/1, source/1, math/2, svg/2, canvas/1, noscript/2, script/2, del/2, ins/2, caption/2, col/1, colgroup/2, table/2, tbody/2, td/2, tfoot/2, th/2, thead/2, tr/2, button/2, datalist/2, fieldset/2, form/2, input/1, label/2, legend/2, meter/2, optgroup/2, option/2, output/2, progress/2, select/2, textarea/2, details/2, dialog/2, summary/2, slot/2, template/2]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-file("src/lustre/element/html.gleam", 11).
?DOC("\n").
-spec html(
    list(lustre@vdom@vattr:attribute(IYG)),
    list(lustre@vdom@vnode:element(IYG))
) -> lustre@vdom@vnode:element(IYG).
html(Attrs, Children) ->
    lustre@element:element(<<"html"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 18).
-spec text(binary()) -> lustre@vdom@vnode:element(any()).
text(Content) ->
    lustre@element:text(Content).

-file("src/lustre/element/html.gleam", 25).
?DOC("\n").
-spec base(list(lustre@vdom@vattr:attribute(IYO))) -> lustre@vdom@vnode:element(IYO).
base(Attrs) ->
    lustre@element:element(<<"base"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 30).
?DOC("\n").
-spec head(
    list(lustre@vdom@vattr:attribute(IYS)),
    list(lustre@vdom@vnode:element(IYS))
) -> lustre@vdom@vnode:element(IYS).
head(Attrs, Children) ->
    lustre@element:element(<<"head"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 38).
?DOC("\n").
-spec link(list(lustre@vdom@vattr:attribute(IYY))) -> lustre@vdom@vnode:element(IYY).
link(Attrs) ->
    lustre@element:element(<<"link"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 43).
?DOC("\n").
-spec meta(list(lustre@vdom@vattr:attribute(IZC))) -> lustre@vdom@vnode:element(IZC).
meta(Attrs) ->
    lustre@element:element(<<"meta"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 48).
?DOC("\n").
-spec style(list(lustre@vdom@vattr:attribute(IZG)), binary()) -> lustre@vdom@vnode:element(IZG).
style(Attrs, Css) ->
    lustre@element:unsafe_raw_html(<<""/utf8>>, <<"style"/utf8>>, Attrs, Css).

-file("src/lustre/element/html.gleam", 53).
?DOC("\n").
-spec title(list(lustre@vdom@vattr:attribute(IZK)), binary()) -> lustre@vdom@vnode:element(IZK).
title(Attrs, Content) ->
    lustre@element:element(<<"title"/utf8>>, Attrs, [text(Content)]).

-file("src/lustre/element/html.gleam", 60).
?DOC("\n").
-spec body(
    list(lustre@vdom@vattr:attribute(IZO)),
    list(lustre@vdom@vnode:element(IZO))
) -> lustre@vdom@vnode:element(IZO).
body(Attrs, Children) ->
    lustre@element:element(<<"body"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 70).
?DOC("\n").
-spec address(
    list(lustre@vdom@vattr:attribute(IZU)),
    list(lustre@vdom@vnode:element(IZU))
) -> lustre@vdom@vnode:element(IZU).
address(Attrs, Children) ->
    lustre@element:element(<<"address"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 78).
?DOC("\n").
-spec article(
    list(lustre@vdom@vattr:attribute(JAA)),
    list(lustre@vdom@vnode:element(JAA))
) -> lustre@vdom@vnode:element(JAA).
article(Attrs, Children) ->
    lustre@element:element(<<"article"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 86).
?DOC("\n").
-spec aside(
    list(lustre@vdom@vattr:attribute(JAG)),
    list(lustre@vdom@vnode:element(JAG))
) -> lustre@vdom@vnode:element(JAG).
aside(Attrs, Children) ->
    lustre@element:element(<<"aside"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 94).
?DOC("\n").
-spec footer(
    list(lustre@vdom@vattr:attribute(JAM)),
    list(lustre@vdom@vnode:element(JAM))
) -> lustre@vdom@vnode:element(JAM).
footer(Attrs, Children) ->
    lustre@element:element(<<"footer"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 102).
?DOC("\n").
-spec header(
    list(lustre@vdom@vattr:attribute(JAS)),
    list(lustre@vdom@vnode:element(JAS))
) -> lustre@vdom@vnode:element(JAS).
header(Attrs, Children) ->
    lustre@element:element(<<"header"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 110).
?DOC("\n").
-spec h1(
    list(lustre@vdom@vattr:attribute(JAY)),
    list(lustre@vdom@vnode:element(JAY))
) -> lustre@vdom@vnode:element(JAY).
h1(Attrs, Children) ->
    lustre@element:element(<<"h1"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 118).
?DOC("\n").
-spec h2(
    list(lustre@vdom@vattr:attribute(JBE)),
    list(lustre@vdom@vnode:element(JBE))
) -> lustre@vdom@vnode:element(JBE).
h2(Attrs, Children) ->
    lustre@element:element(<<"h2"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 126).
?DOC("\n").
-spec h3(
    list(lustre@vdom@vattr:attribute(JBK)),
    list(lustre@vdom@vnode:element(JBK))
) -> lustre@vdom@vnode:element(JBK).
h3(Attrs, Children) ->
    lustre@element:element(<<"h3"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 134).
?DOC("\n").
-spec h4(
    list(lustre@vdom@vattr:attribute(JBQ)),
    list(lustre@vdom@vnode:element(JBQ))
) -> lustre@vdom@vnode:element(JBQ).
h4(Attrs, Children) ->
    lustre@element:element(<<"h4"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 142).
?DOC("\n").
-spec h5(
    list(lustre@vdom@vattr:attribute(JBW)),
    list(lustre@vdom@vnode:element(JBW))
) -> lustre@vdom@vnode:element(JBW).
h5(Attrs, Children) ->
    lustre@element:element(<<"h5"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 150).
?DOC("\n").
-spec h6(
    list(lustre@vdom@vattr:attribute(JCC)),
    list(lustre@vdom@vnode:element(JCC))
) -> lustre@vdom@vnode:element(JCC).
h6(Attrs, Children) ->
    lustre@element:element(<<"h6"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 158).
?DOC("\n").
-spec hgroup(
    list(lustre@vdom@vattr:attribute(JCI)),
    list(lustre@vdom@vnode:element(JCI))
) -> lustre@vdom@vnode:element(JCI).
hgroup(Attrs, Children) ->
    lustre@element:element(<<"hgroup"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 166).
?DOC("\n").
-spec main(
    list(lustre@vdom@vattr:attribute(JCO)),
    list(lustre@vdom@vnode:element(JCO))
) -> lustre@vdom@vnode:element(JCO).
main(Attrs, Children) ->
    lustre@element:element(<<"main"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 174).
?DOC("\n").
-spec nav(
    list(lustre@vdom@vattr:attribute(JCU)),
    list(lustre@vdom@vnode:element(JCU))
) -> lustre@vdom@vnode:element(JCU).
nav(Attrs, Children) ->
    lustre@element:element(<<"nav"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 182).
?DOC("\n").
-spec section(
    list(lustre@vdom@vattr:attribute(JDA)),
    list(lustre@vdom@vnode:element(JDA))
) -> lustre@vdom@vnode:element(JDA).
section(Attrs, Children) ->
    lustre@element:element(<<"section"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 190).
?DOC("\n").
-spec search(
    list(lustre@vdom@vattr:attribute(JDG)),
    list(lustre@vdom@vnode:element(JDG))
) -> lustre@vdom@vnode:element(JDG).
search(Attrs, Children) ->
    lustre@element:element(<<"search"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 200).
?DOC("\n").
-spec blockquote(
    list(lustre@vdom@vattr:attribute(JDM)),
    list(lustre@vdom@vnode:element(JDM))
) -> lustre@vdom@vnode:element(JDM).
blockquote(Attrs, Children) ->
    lustre@element:element(<<"blockquote"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 208).
?DOC("\n").
-spec dd(
    list(lustre@vdom@vattr:attribute(JDS)),
    list(lustre@vdom@vnode:element(JDS))
) -> lustre@vdom@vnode:element(JDS).
dd(Attrs, Children) ->
    lustre@element:element(<<"dd"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 216).
?DOC("\n").
-spec 'div'(
    list(lustre@vdom@vattr:attribute(JDY)),
    list(lustre@vdom@vnode:element(JDY))
) -> lustre@vdom@vnode:element(JDY).
'div'(Attrs, Children) ->
    lustre@element:element(<<"div"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 224).
?DOC("\n").
-spec dl(
    list(lustre@vdom@vattr:attribute(JEE)),
    list(lustre@vdom@vnode:element(JEE))
) -> lustre@vdom@vnode:element(JEE).
dl(Attrs, Children) ->
    lustre@element:element(<<"dl"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 232).
?DOC("\n").
-spec dt(
    list(lustre@vdom@vattr:attribute(JEK)),
    list(lustre@vdom@vnode:element(JEK))
) -> lustre@vdom@vnode:element(JEK).
dt(Attrs, Children) ->
    lustre@element:element(<<"dt"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 240).
?DOC("\n").
-spec figcaption(
    list(lustre@vdom@vattr:attribute(JEQ)),
    list(lustre@vdom@vnode:element(JEQ))
) -> lustre@vdom@vnode:element(JEQ).
figcaption(Attrs, Children) ->
    lustre@element:element(<<"figcaption"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 248).
?DOC("\n").
-spec figure(
    list(lustre@vdom@vattr:attribute(JEW)),
    list(lustre@vdom@vnode:element(JEW))
) -> lustre@vdom@vnode:element(JEW).
figure(Attrs, Children) ->
    lustre@element:element(<<"figure"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 256).
?DOC("\n").
-spec hr(list(lustre@vdom@vattr:attribute(JFC))) -> lustre@vdom@vnode:element(JFC).
hr(Attrs) ->
    lustre@element:element(<<"hr"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 261).
?DOC("\n").
-spec li(
    list(lustre@vdom@vattr:attribute(JFG)),
    list(lustre@vdom@vnode:element(JFG))
) -> lustre@vdom@vnode:element(JFG).
li(Attrs, Children) ->
    lustre@element:element(<<"li"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 269).
?DOC("\n").
-spec menu(
    list(lustre@vdom@vattr:attribute(JFM)),
    list(lustre@vdom@vnode:element(JFM))
) -> lustre@vdom@vnode:element(JFM).
menu(Attrs, Children) ->
    lustre@element:element(<<"menu"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 277).
?DOC("\n").
-spec ol(
    list(lustre@vdom@vattr:attribute(JFS)),
    list(lustre@vdom@vnode:element(JFS))
) -> lustre@vdom@vnode:element(JFS).
ol(Attrs, Children) ->
    lustre@element:element(<<"ol"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 285).
?DOC("\n").
-spec p(
    list(lustre@vdom@vattr:attribute(JFY)),
    list(lustre@vdom@vnode:element(JFY))
) -> lustre@vdom@vnode:element(JFY).
p(Attrs, Children) ->
    lustre@element:element(<<"p"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 293).
?DOC("\n").
-spec pre(
    list(lustre@vdom@vattr:attribute(JGE)),
    list(lustre@vdom@vnode:element(JGE))
) -> lustre@vdom@vnode:element(JGE).
pre(Attrs, Children) ->
    lustre@element:element(<<"pre"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 301).
?DOC("\n").
-spec ul(
    list(lustre@vdom@vattr:attribute(JGK)),
    list(lustre@vdom@vnode:element(JGK))
) -> lustre@vdom@vnode:element(JGK).
ul(Attrs, Children) ->
    lustre@element:element(<<"ul"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 311).
?DOC("\n").
-spec a(
    list(lustre@vdom@vattr:attribute(JGQ)),
    list(lustre@vdom@vnode:element(JGQ))
) -> lustre@vdom@vnode:element(JGQ).
a(Attrs, Children) ->
    lustre@element:element(<<"a"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 319).
?DOC("\n").
-spec abbr(
    list(lustre@vdom@vattr:attribute(JGW)),
    list(lustre@vdom@vnode:element(JGW))
) -> lustre@vdom@vnode:element(JGW).
abbr(Attrs, Children) ->
    lustre@element:element(<<"abbr"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 327).
?DOC("\n").
-spec b(
    list(lustre@vdom@vattr:attribute(JHC)),
    list(lustre@vdom@vnode:element(JHC))
) -> lustre@vdom@vnode:element(JHC).
b(Attrs, Children) ->
    lustre@element:element(<<"b"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 335).
?DOC("\n").
-spec bdi(
    list(lustre@vdom@vattr:attribute(JHI)),
    list(lustre@vdom@vnode:element(JHI))
) -> lustre@vdom@vnode:element(JHI).
bdi(Attrs, Children) ->
    lustre@element:element(<<"bdi"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 343).
?DOC("\n").
-spec bdo(
    list(lustre@vdom@vattr:attribute(JHO)),
    list(lustre@vdom@vnode:element(JHO))
) -> lustre@vdom@vnode:element(JHO).
bdo(Attrs, Children) ->
    lustre@element:element(<<"bdo"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 351).
?DOC("\n").
-spec br(list(lustre@vdom@vattr:attribute(JHU))) -> lustre@vdom@vnode:element(JHU).
br(Attrs) ->
    lustre@element:element(<<"br"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 356).
?DOC("\n").
-spec cite(
    list(lustre@vdom@vattr:attribute(JHY)),
    list(lustre@vdom@vnode:element(JHY))
) -> lustre@vdom@vnode:element(JHY).
cite(Attrs, Children) ->
    lustre@element:element(<<"cite"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 364).
?DOC("\n").
-spec code(
    list(lustre@vdom@vattr:attribute(JIE)),
    list(lustre@vdom@vnode:element(JIE))
) -> lustre@vdom@vnode:element(JIE).
code(Attrs, Children) ->
    lustre@element:element(<<"code"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 372).
?DOC("\n").
-spec data(
    list(lustre@vdom@vattr:attribute(JIK)),
    list(lustre@vdom@vnode:element(JIK))
) -> lustre@vdom@vnode:element(JIK).
data(Attrs, Children) ->
    lustre@element:element(<<"data"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 380).
?DOC("\n").
-spec dfn(
    list(lustre@vdom@vattr:attribute(JIQ)),
    list(lustre@vdom@vnode:element(JIQ))
) -> lustre@vdom@vnode:element(JIQ).
dfn(Attrs, Children) ->
    lustre@element:element(<<"dfn"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 388).
?DOC("\n").
-spec em(
    list(lustre@vdom@vattr:attribute(JIW)),
    list(lustre@vdom@vnode:element(JIW))
) -> lustre@vdom@vnode:element(JIW).
em(Attrs, Children) ->
    lustre@element:element(<<"em"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 396).
?DOC("\n").
-spec i(
    list(lustre@vdom@vattr:attribute(JJC)),
    list(lustre@vdom@vnode:element(JJC))
) -> lustre@vdom@vnode:element(JJC).
i(Attrs, Children) ->
    lustre@element:element(<<"i"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 404).
?DOC("\n").
-spec kbd(
    list(lustre@vdom@vattr:attribute(JJI)),
    list(lustre@vdom@vnode:element(JJI))
) -> lustre@vdom@vnode:element(JJI).
kbd(Attrs, Children) ->
    lustre@element:element(<<"kbd"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 412).
?DOC("\n").
-spec mark(
    list(lustre@vdom@vattr:attribute(JJO)),
    list(lustre@vdom@vnode:element(JJO))
) -> lustre@vdom@vnode:element(JJO).
mark(Attrs, Children) ->
    lustre@element:element(<<"mark"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 420).
?DOC("\n").
-spec q(
    list(lustre@vdom@vattr:attribute(JJU)),
    list(lustre@vdom@vnode:element(JJU))
) -> lustre@vdom@vnode:element(JJU).
q(Attrs, Children) ->
    lustre@element:element(<<"q"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 428).
?DOC("\n").
-spec rp(
    list(lustre@vdom@vattr:attribute(JKA)),
    list(lustre@vdom@vnode:element(JKA))
) -> lustre@vdom@vnode:element(JKA).
rp(Attrs, Children) ->
    lustre@element:element(<<"rp"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 436).
?DOC("\n").
-spec rt(
    list(lustre@vdom@vattr:attribute(JKG)),
    list(lustre@vdom@vnode:element(JKG))
) -> lustre@vdom@vnode:element(JKG).
rt(Attrs, Children) ->
    lustre@element:element(<<"rt"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 444).
?DOC("\n").
-spec ruby(
    list(lustre@vdom@vattr:attribute(JKM)),
    list(lustre@vdom@vnode:element(JKM))
) -> lustre@vdom@vnode:element(JKM).
ruby(Attrs, Children) ->
    lustre@element:element(<<"ruby"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 452).
?DOC("\n").
-spec s(
    list(lustre@vdom@vattr:attribute(JKS)),
    list(lustre@vdom@vnode:element(JKS))
) -> lustre@vdom@vnode:element(JKS).
s(Attrs, Children) ->
    lustre@element:element(<<"s"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 460).
?DOC("\n").
-spec samp(
    list(lustre@vdom@vattr:attribute(JKY)),
    list(lustre@vdom@vnode:element(JKY))
) -> lustre@vdom@vnode:element(JKY).
samp(Attrs, Children) ->
    lustre@element:element(<<"samp"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 468).
?DOC("\n").
-spec small(
    list(lustre@vdom@vattr:attribute(JLE)),
    list(lustre@vdom@vnode:element(JLE))
) -> lustre@vdom@vnode:element(JLE).
small(Attrs, Children) ->
    lustre@element:element(<<"small"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 476).
?DOC("\n").
-spec span(
    list(lustre@vdom@vattr:attribute(JLK)),
    list(lustre@vdom@vnode:element(JLK))
) -> lustre@vdom@vnode:element(JLK).
span(Attrs, Children) ->
    lustre@element:element(<<"span"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 484).
?DOC("\n").
-spec strong(
    list(lustre@vdom@vattr:attribute(JLQ)),
    list(lustre@vdom@vnode:element(JLQ))
) -> lustre@vdom@vnode:element(JLQ).
strong(Attrs, Children) ->
    lustre@element:element(<<"strong"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 492).
?DOC("\n").
-spec sub(
    list(lustre@vdom@vattr:attribute(JLW)),
    list(lustre@vdom@vnode:element(JLW))
) -> lustre@vdom@vnode:element(JLW).
sub(Attrs, Children) ->
    lustre@element:element(<<"sub"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 500).
?DOC("\n").
-spec sup(
    list(lustre@vdom@vattr:attribute(JMC)),
    list(lustre@vdom@vnode:element(JMC))
) -> lustre@vdom@vnode:element(JMC).
sup(Attrs, Children) ->
    lustre@element:element(<<"sup"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 508).
?DOC("\n").
-spec time(
    list(lustre@vdom@vattr:attribute(JMI)),
    list(lustre@vdom@vnode:element(JMI))
) -> lustre@vdom@vnode:element(JMI).
time(Attrs, Children) ->
    lustre@element:element(<<"time"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 516).
?DOC("\n").
-spec u(
    list(lustre@vdom@vattr:attribute(JMO)),
    list(lustre@vdom@vnode:element(JMO))
) -> lustre@vdom@vnode:element(JMO).
u(Attrs, Children) ->
    lustre@element:element(<<"u"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 524).
?DOC("\n").
-spec var(
    list(lustre@vdom@vattr:attribute(JMU)),
    list(lustre@vdom@vnode:element(JMU))
) -> lustre@vdom@vnode:element(JMU).
var(Attrs, Children) ->
    lustre@element:element(<<"var"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 532).
?DOC("\n").
-spec wbr(list(lustre@vdom@vattr:attribute(JNA))) -> lustre@vdom@vnode:element(JNA).
wbr(Attrs) ->
    lustre@element:element(<<"wbr"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 539).
?DOC("\n").
-spec area(list(lustre@vdom@vattr:attribute(JNE))) -> lustre@vdom@vnode:element(JNE).
area(Attrs) ->
    lustre@element:element(<<"area"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 544).
?DOC("\n").
-spec audio(
    list(lustre@vdom@vattr:attribute(JNI)),
    list(lustre@vdom@vnode:element(JNI))
) -> lustre@vdom@vnode:element(JNI).
audio(Attrs, Children) ->
    lustre@element:element(<<"audio"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 552).
?DOC("\n").
-spec img(list(lustre@vdom@vattr:attribute(JNO))) -> lustre@vdom@vnode:element(JNO).
img(Attrs) ->
    lustre@element:element(<<"img"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 558).
?DOC(" Used with <area> elements to define an image map (a clickable link area).\n").
-spec map(
    list(lustre@vdom@vattr:attribute(JNS)),
    list(lustre@vdom@vnode:element(JNS))
) -> lustre@vdom@vnode:element(JNS).
map(Attrs, Children) ->
    lustre@element:element(<<"map"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 566).
?DOC("\n").
-spec track(list(lustre@vdom@vattr:attribute(JNY))) -> lustre@vdom@vnode:element(JNY).
track(Attrs) ->
    lustre@element:element(<<"track"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 571).
?DOC("\n").
-spec video(
    list(lustre@vdom@vattr:attribute(JOC)),
    list(lustre@vdom@vnode:element(JOC))
) -> lustre@vdom@vnode:element(JOC).
video(Attrs, Children) ->
    lustre@element:element(<<"video"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 581).
?DOC("\n").
-spec embed(list(lustre@vdom@vattr:attribute(JOI))) -> lustre@vdom@vnode:element(JOI).
embed(Attrs) ->
    lustre@element:element(<<"embed"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 586).
?DOC("\n").
-spec iframe(list(lustre@vdom@vattr:attribute(JOM))) -> lustre@vdom@vnode:element(JOM).
iframe(Attrs) ->
    lustre@element:element(<<"iframe"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 591).
?DOC("\n").
-spec object(list(lustre@vdom@vattr:attribute(JOQ))) -> lustre@vdom@vnode:element(JOQ).
object(Attrs) ->
    lustre@element:element(<<"object"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 596).
?DOC("\n").
-spec picture(
    list(lustre@vdom@vattr:attribute(JOU)),
    list(lustre@vdom@vnode:element(JOU))
) -> lustre@vdom@vnode:element(JOU).
picture(Attrs, Children) ->
    lustre@element:element(<<"picture"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 604).
?DOC("\n").
-spec portal(list(lustre@vdom@vattr:attribute(JPA))) -> lustre@vdom@vnode:element(JPA).
portal(Attrs) ->
    lustre@element:element(<<"portal"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 609).
?DOC("\n").
-spec source(list(lustre@vdom@vattr:attribute(JPE))) -> lustre@vdom@vnode:element(JPE).
source(Attrs) ->
    lustre@element:element(<<"source"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 616).
?DOC("\n").
-spec math(
    list(lustre@vdom@vattr:attribute(JPI)),
    list(lustre@vdom@vnode:element(JPI))
) -> lustre@vdom@vnode:element(JPI).
math(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/1998/Math/MathML"/utf8>>,
        <<"math"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/html.gleam", 624).
?DOC("\n").
-spec svg(
    list(lustre@vdom@vattr:attribute(JPO)),
    list(lustre@vdom@vnode:element(JPO))
) -> lustre@vdom@vnode:element(JPO).
svg(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"svg"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/html.gleam", 634).
?DOC("\n").
-spec canvas(list(lustre@vdom@vattr:attribute(JPU))) -> lustre@vdom@vnode:element(JPU).
canvas(Attrs) ->
    lustre@element:element(<<"canvas"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 639).
?DOC("\n").
-spec noscript(
    list(lustre@vdom@vattr:attribute(JPY)),
    list(lustre@vdom@vnode:element(JPY))
) -> lustre@vdom@vnode:element(JPY).
noscript(Attrs, Children) ->
    lustre@element:element(<<"noscript"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 647).
?DOC("\n").
-spec script(list(lustre@vdom@vattr:attribute(JQE)), binary()) -> lustre@vdom@vnode:element(JQE).
script(Attrs, Js) ->
    lustre@element:unsafe_raw_html(<<""/utf8>>, <<"script"/utf8>>, Attrs, Js).

-file("src/lustre/element/html.gleam", 654).
?DOC("\n").
-spec del(
    list(lustre@vdom@vattr:attribute(JQI)),
    list(lustre@vdom@vnode:element(JQI))
) -> lustre@vdom@vnode:element(JQI).
del(Attrs, Children) ->
    lustre@element:element(<<"del"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 662).
?DOC("\n").
-spec ins(
    list(lustre@vdom@vattr:attribute(JQO)),
    list(lustre@vdom@vnode:element(JQO))
) -> lustre@vdom@vnode:element(JQO).
ins(Attrs, Children) ->
    lustre@element:element(<<"ins"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 672).
?DOC("\n").
-spec caption(
    list(lustre@vdom@vattr:attribute(JQU)),
    list(lustre@vdom@vnode:element(JQU))
) -> lustre@vdom@vnode:element(JQU).
caption(Attrs, Children) ->
    lustre@element:element(<<"caption"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 680).
?DOC("\n").
-spec col(list(lustre@vdom@vattr:attribute(JRA))) -> lustre@vdom@vnode:element(JRA).
col(Attrs) ->
    lustre@element:element(<<"col"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 685).
?DOC("\n").
-spec colgroup(
    list(lustre@vdom@vattr:attribute(JRE)),
    list(lustre@vdom@vnode:element(JRE))
) -> lustre@vdom@vnode:element(JRE).
colgroup(Attrs, Children) ->
    lustre@element:element(<<"colgroup"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 693).
?DOC("\n").
-spec table(
    list(lustre@vdom@vattr:attribute(JRK)),
    list(lustre@vdom@vnode:element(JRK))
) -> lustre@vdom@vnode:element(JRK).
table(Attrs, Children) ->
    lustre@element:element(<<"table"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 701).
?DOC("\n").
-spec tbody(
    list(lustre@vdom@vattr:attribute(JRQ)),
    list(lustre@vdom@vnode:element(JRQ))
) -> lustre@vdom@vnode:element(JRQ).
tbody(Attrs, Children) ->
    lustre@element:element(<<"tbody"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 709).
?DOC("\n").
-spec td(
    list(lustre@vdom@vattr:attribute(JRW)),
    list(lustre@vdom@vnode:element(JRW))
) -> lustre@vdom@vnode:element(JRW).
td(Attrs, Children) ->
    lustre@element:element(<<"td"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 717).
?DOC("\n").
-spec tfoot(
    list(lustre@vdom@vattr:attribute(JSC)),
    list(lustre@vdom@vnode:element(JSC))
) -> lustre@vdom@vnode:element(JSC).
tfoot(Attrs, Children) ->
    lustre@element:element(<<"tfoot"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 725).
?DOC("\n").
-spec th(
    list(lustre@vdom@vattr:attribute(JSI)),
    list(lustre@vdom@vnode:element(JSI))
) -> lustre@vdom@vnode:element(JSI).
th(Attrs, Children) ->
    lustre@element:element(<<"th"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 733).
?DOC("\n").
-spec thead(
    list(lustre@vdom@vattr:attribute(JSO)),
    list(lustre@vdom@vnode:element(JSO))
) -> lustre@vdom@vnode:element(JSO).
thead(Attrs, Children) ->
    lustre@element:element(<<"thead"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 741).
?DOC("\n").
-spec tr(
    list(lustre@vdom@vattr:attribute(JSU)),
    list(lustre@vdom@vnode:element(JSU))
) -> lustre@vdom@vnode:element(JSU).
tr(Attrs, Children) ->
    lustre@element:element(<<"tr"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 751).
?DOC("\n").
-spec button(
    list(lustre@vdom@vattr:attribute(JTA)),
    list(lustre@vdom@vnode:element(JTA))
) -> lustre@vdom@vnode:element(JTA).
button(Attrs, Children) ->
    lustre@element:element(<<"button"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 759).
?DOC("\n").
-spec datalist(
    list(lustre@vdom@vattr:attribute(JTG)),
    list(lustre@vdom@vnode:element(JTG))
) -> lustre@vdom@vnode:element(JTG).
datalist(Attrs, Children) ->
    lustre@element:element(<<"datalist"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 767).
?DOC("\n").
-spec fieldset(
    list(lustre@vdom@vattr:attribute(JTM)),
    list(lustre@vdom@vnode:element(JTM))
) -> lustre@vdom@vnode:element(JTM).
fieldset(Attrs, Children) ->
    lustre@element:element(<<"fieldset"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 775).
?DOC("\n").
-spec form(
    list(lustre@vdom@vattr:attribute(JTS)),
    list(lustre@vdom@vnode:element(JTS))
) -> lustre@vdom@vnode:element(JTS).
form(Attrs, Children) ->
    lustre@element:element(<<"form"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 783).
?DOC("\n").
-spec input(list(lustre@vdom@vattr:attribute(JTY))) -> lustre@vdom@vnode:element(JTY).
input(Attrs) ->
    lustre@element:element(<<"input"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 788).
?DOC("\n").
-spec label(
    list(lustre@vdom@vattr:attribute(JUC)),
    list(lustre@vdom@vnode:element(JUC))
) -> lustre@vdom@vnode:element(JUC).
label(Attrs, Children) ->
    lustre@element:element(<<"label"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 796).
?DOC("\n").
-spec legend(
    list(lustre@vdom@vattr:attribute(JUI)),
    list(lustre@vdom@vnode:element(JUI))
) -> lustre@vdom@vnode:element(JUI).
legend(Attrs, Children) ->
    lustre@element:element(<<"legend"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 804).
?DOC("\n").
-spec meter(
    list(lustre@vdom@vattr:attribute(JUO)),
    list(lustre@vdom@vnode:element(JUO))
) -> lustre@vdom@vnode:element(JUO).
meter(Attrs, Children) ->
    lustre@element:element(<<"meter"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 812).
?DOC("\n").
-spec optgroup(
    list(lustre@vdom@vattr:attribute(JUU)),
    list(lustre@vdom@vnode:element(JUU))
) -> lustre@vdom@vnode:element(JUU).
optgroup(Attrs, Children) ->
    lustre@element:element(<<"optgroup"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 820).
?DOC("\n").
-spec option(list(lustre@vdom@vattr:attribute(JVA)), binary()) -> lustre@vdom@vnode:element(JVA).
option(Attrs, Label) ->
    lustre@element:element(
        <<"option"/utf8>>,
        Attrs,
        [lustre@element:text(Label)]
    ).

-file("src/lustre/element/html.gleam", 825).
?DOC("\n").
-spec output(
    list(lustre@vdom@vattr:attribute(JVE)),
    list(lustre@vdom@vnode:element(JVE))
) -> lustre@vdom@vnode:element(JVE).
output(Attrs, Children) ->
    lustre@element:element(<<"output"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 833).
?DOC("\n").
-spec progress(
    list(lustre@vdom@vattr:attribute(JVK)),
    list(lustre@vdom@vnode:element(JVK))
) -> lustre@vdom@vnode:element(JVK).
progress(Attrs, Children) ->
    lustre@element:element(<<"progress"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 841).
?DOC("\n").
-spec select(
    list(lustre@vdom@vattr:attribute(JVQ)),
    list(lustre@vdom@vnode:element(JVQ))
) -> lustre@vdom@vnode:element(JVQ).
select(Attrs, Children) ->
    lustre@element:element(<<"select"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 849).
?DOC("\n").
-spec textarea(list(lustre@vdom@vattr:attribute(JVW)), binary()) -> lustre@vdom@vnode:element(JVW).
textarea(Attrs, Content) ->
    lustre@element:element(
        <<"textarea"/utf8>>,
        [lustre@attribute:property(<<"value"/utf8>>, gleam@json:string(Content)) |
            Attrs],
        [lustre@element:text(Content)]
    ).

-file("src/lustre/element/html.gleam", 860).
?DOC("\n").
-spec details(
    list(lustre@vdom@vattr:attribute(JWA)),
    list(lustre@vdom@vnode:element(JWA))
) -> lustre@vdom@vnode:element(JWA).
details(Attrs, Children) ->
    lustre@element:element(<<"details"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 868).
?DOC("\n").
-spec dialog(
    list(lustre@vdom@vattr:attribute(JWG)),
    list(lustre@vdom@vnode:element(JWG))
) -> lustre@vdom@vnode:element(JWG).
dialog(Attrs, Children) ->
    lustre@element:element(<<"dialog"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 876).
?DOC("\n").
-spec summary(
    list(lustre@vdom@vattr:attribute(JWM)),
    list(lustre@vdom@vnode:element(JWM))
) -> lustre@vdom@vnode:element(JWM).
summary(Attrs, Children) ->
    lustre@element:element(<<"summary"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 886).
?DOC("\n").
-spec slot(
    list(lustre@vdom@vattr:attribute(JWS)),
    list(lustre@vdom@vnode:element(JWS))
) -> lustre@vdom@vnode:element(JWS).
slot(Attrs, Fallback) ->
    lustre@element:element(<<"slot"/utf8>>, Attrs, Fallback).

-file("src/lustre/element/html.gleam", 894).
?DOC("\n").
-spec template(
    list(lustre@vdom@vattr:attribute(JWY)),
    list(lustre@vdom@vnode:element(JWY))
) -> lustre@vdom@vnode:element(JWY).
template(Attrs, Children) ->
    lustre@element:element(<<"template"/utf8>>, Attrs, Children).
