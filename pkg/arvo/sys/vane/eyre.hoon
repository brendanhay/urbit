!:
::  lighter than eyre
::
|=  pit=vase
=,  eyre
::  internal data structures
::
=>  =~
::
::  internal data structures that won't go in zuse
::
|%
+$  move
  ::
  $:  ::  duct: request identifier
      ::
      =duct
      ::
      ::
      card=(wind note gift:able)
  ==
::  +note: private request from eyre to another vane
::
+$  note
  $%  ::  %b: to behn
      ::
      $:  %b
          ::
          ::
          $%  [%rest p=@da]
              [%wait p=@da]
      ==  ==
      ::  %d: to dill
      ::
      $:  %d
          ::
          ::
      $%  [%flog =flog:dill]
      ==  ==
      ::  %g: to gall
      ::
      $:  %g
          ::
          ::
          $>(%deal task:able:gall)
  ==  ==
::  +sign: private response from another vane to eyre
::
+$  sign
  $%  ::  %b: from behn
      ::
      $:  %b
          ::
          ::
          $%  [%wake error=(unit tang)]
      ==  ==
      ::  %g: from gall
      ::
      $:  %g
          ::
          ::
          gift:able:gall
          ::  $>(%unto gift:able:gall)
  ==  ==
--
::  more structures
::
|%
++  axle
  $:  ::  date: date at which http-server's state was updated to this data structure
      ::
      date=%~2020.5.29
      ::  server-state: state of inbound requests
      ::
      =server-state
  ==
::  +server-state: state relating to open inbound HTTP connections
::
+$  server-state
  $:  ::  bindings: actions to dispatch to when a binding matches
      ::
      ::    Eyre is responsible for keeping its bindings sorted so that it
      ::    will trigger on the most specific binding first. Eyre should send
      ::    back an error response if an already bound binding exists.
      ::
      ::    TODO: It would be nice if we had a path trie. We could decompose
      ::    the :binding into a (map (unit @t) (trie knot =action)).
      ::
      bindings=(list [=binding =duct =action])
      ::  connections: open http connections not fully complete
      ::
      connections=(map duct outstanding-connection)
      ::  authentication-state: state managed by the +authentication core
      ::
      =authentication-state
      ::  channel-state: state managed by the +channel core
      ::
      =channel-state
      ::  domains: domain-names that resolve to us
      ::
      domains=(set turf)
      ::  http-config: our server configuration
      ::
      =http-config
      ::  ports: live servers
      ::
      ports=[insecure=@ud secure=(unit @ud)]
      ::  outgoing-duct: to unix
      ::
      outgoing-duct=duct
  ==
::  channel-request: an action requested on a channel
::
+$  channel-request
  $%  ::  %ack: acknowledges that the client has received events up to :id
      ::
      [%ack event-id=@ud]
      ::  %poke: pokes an application, translating :json to :mark.
      ::
      [%poke request-id=@ud ship=@p app=term mark=@tas =json]
      ::  %watch: subscribes to an application path
      ::
      [%subscribe request-id=@ud ship=@p app=term =path]
      ::  %leave: unsubscribes from an application path
      ::
      [%unsubscribe request-id=@ud subscription-id=@ud]
      ::  %delete: kills a channel
      ::
      [%delete ~]
  ==
::  channel-timeout: the delay before a channel should be reaped
::
++  channel-timeout  ~h12
::  session-timeout: the delay before an idle session expires
::
++  session-timeout  ~d7
--
::  utilities
::
|%
::  +combine-octs: combine multiple octs into one
::
++  combine-octs
  |=  a=(list octs)
  ^-  octs
  :-  %+  roll  a
      |=  [=octs sum=@ud]
      (add sum p.octs)
  (can 3 a)
::  +prune-events: removes all items from the front of the queue up to :id
::
++  prune-events
  |=  [q=(qeu [id=@ud lines=wall]) id=@ud]
  ^+  q
  ::  if the queue is now empty, that's fine
  ::
  ?:  =(~ q)
    ~
  ::
  =/  next=[item=[id=@ud lines=wall] _q]  ~(get to q)
  ::  if the head of the queue is newer than the acknowledged id, we're done
  ::
  ?:  (gth id.item.next id)
    q
  ::  otherwise, check next item
  ::
  $(q +:next)
::  +parse-channel-request: parses a list of channel-requests
::
::    Parses a json array into a list of +channel-request. If any of the items
::    in the list fail to parse, the entire thing fails so we can 400 properly
::    to the client.
::
++  parse-channel-request
  |=  request-list=json
  ^-  (unit (list channel-request))
  ::  parse top
  ::
  =,  dejs-soft:format
  =-  ((ar -) request-list)
  ::
  |=  item=json
  ^-  (unit channel-request)
  ::
  ?~  maybe-key=((ot action+so ~) item)
    ~
  ?:  =('ack' u.maybe-key)
    ((pe %ack (ot event-id+ni ~)) item)
  ?:  =('poke' u.maybe-key)
    ((pe %poke (ot id+ni ship+(su fed:ag) app+so mark+(su sym) json+some ~)) item)
  ?:  =('subscribe' u.maybe-key)
    %.  item
    %+  pe  %subscribe
    (ot id+ni ship+(su fed:ag) app+so path+(su ;~(pfix fas (more fas urs:ab))) ~)
  ?:  =('unsubscribe' u.maybe-key)
    %.  item
    %+  pe  %unsubscribe
    (ot id+ni subscription+ni ~)
  ?:  =('delete' u.maybe-key)
    `[%delete ~]
  ::  if we reached this, we have an invalid action key. fail parsing.
  ::
  ~
::  +login-page: internal page to login to an Urbit
::
++  login-page
  |=  [redirect-url=(unit @t) our=@p]
  ^-  octs
  =+  redirect-str=?~(redirect-url "" (trip u.redirect-url))
  %-  as-octs:mimes:html
  %-  crip
  %-  en-xml:html
  ;html
    ;head
      ;meta(charset "utf-8");
      ;meta(name "viewport", content "width=device-width, initial-scale=1, shrink-to-fit=no");
      ;title:"OS1"
      ;style:'''
             @import url("https://rsms.me/inter/inter.css");
             @font-face {
                 font-family: "Source Code Pro";
                 src: url("https://storage.googleapis.com/media.urbit.org/fonts/scp-regular.woff");
                 font-weight: 400;
             }
             html, body {
               font-family: Inter, sans-serif;
               height: 100%;
               margin: 0 !important;
               width: 100%;
               background: #fff;
               color: #000;
               -webkit-font-smoothing: antialiased;
               line-height: 1.5;
               font-size: 12pt;
             }
             a, a:visited {
               color: #000;
               text-decoration: none;
               font-size: 0.875rem;
             }
             p {
               margin-block-start: 0;
               margin-block-end: 0;
               font-size: 0.875rem;
             }
             input {
               width: 100%;
               padding: 0.75rem;
               border: 1px solid #e6e6e6;
               margin-top: 0.25rem;
               margin-bottom: 1rem;
               font-size: 0.875rem;
             }
             input:focus {
               outline: 0;
               border: 1px solid #000;
             }
             button {
               -webkit-appearance: none;
               padding: 0.75rem;
               background-color: #eee;
               border: 1px solid #d1d2d3;
               color: #666;
               font-size: 0.875rem;
               border-radius: 0;
             }
             footer {
               position: absolute;
               bottom: 0;
             }
             .mono {
               font-family: "Source Code Pro", monospace;
             }
             .gray2 {
               color: #7f7f7f;
             }
             .f9 {
               font-size: 0.75rem;
             }
             .relative {
               position: relative;
             }
             .absolute {
               position: absolute;
             }
             .w-100 {
               width: 100%;
             }
             .tr {
               text-align: right;
             }
             .pb2 {
               padding-bottom: 0.5rem;
             }
             .pr1 {
               padding-right: 0.25rem;
             }
             .pr2 {
               padding-right: .5rem;
             }
             .dn {
               display: none;
             }
             #main {
               width: 100%;
               height: 100%;
             }
             #inner {
               position: fixed;
               top: 50%;
               left: 50%;
               transform: translate(-50%, -50%);
             }
             @media all and (prefers-color-scheme: dark) {
               html, body {
                 background-color: #333;
                 color: #fff;
               }
               a, a:visited {
                 color: #fff;
               }
               input {
                 background: #333;
                 color: #fff;
                 border: 1px solid #7f7f7f;
               }
               input:focus {
                 border: 1px solid #fff;
               }
             }
             @media all and (min-width: 34.375rem) {
               .tc-ns {
                 text-align: center;
               }
               .pr0-ns {
                 padding-right: 0;
               }
               .dib-ns {
                 display: inline-block;
               }
             }
             '''
    ==
    ;body
      ;div#main
        ;div#inner
          ;p:"Urbit ID"
          ;input(value "{(scow %p our)}", disabled "true", class "mono");
          ;p:"Access Key"
          ;p.f9.gray2
            ; Get key from Bridge, or
            ;span.mono.pr1:"+code"
            ; in dojo
          ==
          ;form(action "/~/login", method "post", enctype "application/x-www-form-urlencoded")
            ;input
              =type  "password"
              =name  "password"
              =placeholder  "sampel-ticlyt-migfun-falmel"
              =class  "mono"
              =autofocus  "true";
            ;input(type "hidden", name "redirect", value redirect-str);
            ;button(type "submit"):"Continue"
          ==
        ==
        ;footer.absolute.w-100
          ;div.relative.w-100.tr.tc-ns
            ;p.pr2.pr0-ns.pb2
              ;a(href "https://bridge.urbit.org", target "_blank")
                ;span.dn.dib-ns.pr1:"Open"
                ; Bridge ↗
              ==
              ;a
                =href  "https://urbit.org/using/install/#id"
                =style  "margin-left: 8px; color: #2aa779;"
                =target  "_blank"
                ; Purchase
                ;span.dn.dib-ns.pr1:"an Urbit ID"
                ; ↗
              ==
            ==
          ==
        ==
      ==
    ==
  ==
::  +render-tang-to-marl: renders a tang and adds <br/> tags between each line
::
++  render-tang-to-marl
  |=  {wid/@u tan/tang}
  ^-  marl
  =/  raw=(list tape)  (zing (turn tan |=(a/tank (wash 0^wid a))))
  ::
  |-  ^-  marl
  ?~  raw  ~
  [;/(i.raw) ;br; $(raw t.raw)]
::  +render-tang-to-wall: renders tang as text lines
::
++  render-tang-to-wall
  |=  {wid/@u tan/tang}
  ^-  wall
  (zing (turn tan |=(a=tank (wash 0^wid a))))
::  +wall-to-octs: text to binary output
::
++  wall-to-octs
  |=  =wall
  ^-  (unit octs)
  ::
  ?:  =(~ wall)
    ~
  ::
  :-  ~
  %-  as-octs:mimes:html
  %-  crip
  %-  zing
  %+  turn  wall
  |=  t=tape
  "{t}\0a"
::  +internal-server-error: 500 page, with a tang
::
++  internal-server-error
  |=  [authorized=? url=@t t=tang]
  ^-  octs
  %-  as-octs:mimes:html
  %-  crip
  %-  en-xml:html
  ;html
    ;head
      ;title:"500 Internal Server Error"
    ==
    ;body
      ;h1:"Internal Server Error"
      ;p:"There was an error while handling the request for {<(trip url)>}."
      ;*  ?:  authorized
            ;=
              ;code:"*{(render-tang-to-marl 80 t)}"
            ==
          ~
    ==
  ==
::  +error-page: error page, with an error string if logged in
::
++  error-page
  |=  [code=@ud authorized=? url=@t t=tape]
  ^-  octs
  ::
  =/  code-as-tape=tape  (format-ud-as-integer code)
  =/  message=tape
    ?+  code  "{<code>} Error"
      %400  "Bad Request"
      %403  "Forbidden"
      %404  "Not Found"
      %405  "Method Not Allowed"
      %500  "Internal Server Error"
    ==
  ::
  %-  as-octs:mimes:html
  %-  crip
  %-  en-xml:html
  ;html
    ;head
      ;title:"{code-as-tape} {message}"
    ==
    ;body
      ;h1:"{message}"
      ;p:"There was an error while handling the request for {<(trip url)>}."
      ;*  ?:  authorized
            ;=
              ;code:"{t}"
            ==
          ~
    ==
  ==
::  +format-ud-as-integer: prints a number for consumption outside urbit
::
++  format-ud-as-integer
  |=  a=@ud
  ^-  tape
  ?:  =(0 a)  ['0' ~]
  %-  flop
  |-  ^-  tape
  ?:(=(0 a) ~ [(add '0' (mod a 10)) $(a (div a 10))])
::  +host-matches: %.y if the site :binding should be used to handle :host
::
++  host-matches
  |=  [binding=(unit @t) host=(unit @t)]
  ^-  ?
  ::  if the binding allows for matching anything, match
  ::
  ?~  binding
    %.y
  ::  if the host is ~, that means we're trying to bind nothing to a real
  ::  binding. fail.
  ::
  ?~  host
    %.n
  ::  otherwise, do a straight comparison
  ::
  =(u.binding u.host)
::  +find-suffix: returns [~ /tail] if :full is (weld :prefix /tail)
::
++  find-suffix
  |=  [prefix=path full=path]
  ^-  (unit path)
  ?~  prefix
    `full
  ?~  full
    ~
  ?.  =(i.prefix i.full)
    ~
  $(prefix t.prefix, full t.full)
::  +simplified-url-parser: returns [(each @if @t) (unit port=@ud)]
::
++  simplified-url-parser
  ;~  plug
    ;~  pose
      %+  stag  %ip
      =+  tod=(ape:ag ted:ab)
      %+  bass  256
      ;~(plug tod (stun [3 3] ;~(pfix dot tod)))
    ::
      (stag %site (cook crip (star ;~(pose dot alp))))
    ==
    ;~  pose
      (stag ~ ;~(pfix col dim:ag))
      (easy ~)
    ==
  ==
::  +per-server-event: per-event server core
::
++  per-server-event
  ::  gate that produces the +per-server-event core from event information
  ::
  |=  [[our=@p eny=@ =duct now=@da scry=sley] state=server-state]
  =/  eyre-id  (scot %ta (cat 3 'eyre_' (scot %uv (sham duct))))
  |%
  ::  +request-local: bypass authentication for local lens connections
  ::
  ++  request-local
    |=  [secure=? =address =request:http]
    ^-  [(list move) server-state]
    ::
    =/  act  [%app app=%lens]
    ::
    =/  connection=outstanding-connection
      [act [& secure address request] ~ 0]
    ::
    =.  connections.state
      (~(put by connections.state) duct connection)
    ::
    :_  state
    (subscribe-to-app app.act inbound-request.connection)
  ::  +request: starts handling an inbound http request
  ::
  ++  request
    |=  [secure=? =address =request:http]
    ^-  [(list move) server-state]
    ::  for requests from localhost, respect the "forwarded" header
    ::
    =?  address  =([%ipv4 .127.0.0.1] address)
      (fall (forwarded-for header-list.request) address)
    ::
    =/  host  (get-header:http 'host' header-list.request)
    =/  [=action suburl=@t]
      (get-action-for-binding host url.request)
    ::
    =/  authenticated  (request-is-logged-in:authentication request)
    ::  record that we started an asynchronous response
    ::
    =/  connection=outstanding-connection
      [action [authenticated secure address request] ~ 0]
    =.  connections.state
      (~(put by connections.state) duct connection)
    ::
    ?-    -.action
        %gen
      =/  bek=beak  [our desk.generator.action da+now]
      =/  sup=spur  (flop path.generator.action)
      =/  ski       (scry [%141 %noun] ~ %ca bek sup)
      =/  cag=cage  (need (need ski))
      ?>  =(%vase p.cag)
      =/  gat=vase  !<(vase q.cag)
      =/  res=toon
        %-  mock  :_  (sloy scry)
        :_  [%9 2 %0 1]  |.
        %+  slam
          %+  slam  gat
          !>([[now=now eny=eny bek=bek] ~ ~])
        !>([authenticated request])
      ?:  ?=(%2 -.res)
        =+  connection=(~(got by connections.state) duct)
        %^  return-static-data-on-duct  500  'text/html'
        %:  internal-server-error
            authenticated.inbound-request.connection
            url.request.inbound-request.connection
            leaf+"generator crashed"
            p.res
        ==
      ?:  ?=(%1 -.res)
        =+  connection=(~(got by connections.state) duct)
        %^  return-static-data-on-duct  500  'text/html'
        %:  internal-server-error
            authenticated.inbound-request.connection
            url.request.inbound-request.connection
            leaf+"scry blocked on"
            >p.res<
            ~
        ==
      =/  result  ;;(simple-payload:http +.p.res)
      ::  ensure we have a valid content-length header
      ::
      ::    We pass on the response and the headers the generator produces, but
      ::    ensure that we have a single content-length header set correctly in
      ::    the returned if this has a body, and has no content-length if there
      ::    is no body returned to the client.
      ::
      =.  headers.response-header.result
        ?~  data.result
          (delete-header:http 'content-length' headers.response-header.result)
        ::
        %^  set-header:http  'content-length'
          (crip (format-ud-as-integer p.u.data.result))
        headers.response-header.result
      ::
      %-  handle-response
      ^-  http-event:http
      :*  %start
          response-header.result
          data.result
          complete=%.y
      ==
    ::
        %app
      :_  state
      (subscribe-to-app app.action inbound-request.connection)
    ::
        %authentication
      (handle-request:authentication secure address request)
    ::
        %logout
      (handle-logout:authentication authenticated request)
    ::
        %channel
      (handle-request:by-channel secure authenticated address request)
    ::
        %scry
      (handle-scry authenticated address request(url suburl))
    ::
        %four-oh-four
      %^  return-static-data-on-duct  404  'text/html'
      (error-page 404 authenticated url.request ~)
    ==
  ::  +handle-scry: respond with scry result, 404 or 500
  ::
  ++  handle-scry
    |=  [authenticated=? =address =request:http]
    |^  ^-  (quip move server-state)
    ?.  authenticated
      (error-response 403 ~)
    ?.  =(%'GET' method.request)
      (error-response 405 "may only GET scries")
    ::  make sure the path contains an app to scry into
    ::
    =+  req=(parse-request-line url.request)
    ?.  ?=(^ site.req)
      (error-response 400 "scry path must start with app name")
    ::  attempt the scry that was asked for
    ::
    =/  res=(unit (unit cage))
      (do-scry %gx i.site.req (snoc t.site.req (fall ext.req %mime)))
    ?~  res    (error-response 500 "failed scry")
    ?~  u.res  (error-response 404 "no scry result")
    =*  mark   p.u.u.res
    =*  vase   q.u.u.res
    ::  attempt to find conversion gate to mime
    ::
    =/  tub=(unit tube:clay)
      (find-tube mark %mime)
    ?~  tub  (error-response 500 "no tube from {(trip mark)} to mime")
    ::  attempt conversion, then send results
    ::
    =/  mym=(each mime tang)
      (mule |.(!<(mime (u.tub vase))))
    ?-  -.mym
      %|  (error-response 500 "failed tube from {(trip mark)} to mime")
      %&  %+  return-static-data-on-duct  200
          [(rsh 3 1 (spat p.p.mym)) q.p.mym]
    ==
    ::
    ++  find-tube
      |=  [from=mark to=mark]
      ^-  (unit tube:clay)
      ?:  =(from to)  `(bake same vase)
      =/  tub=(unit (unit cage))
        (do-scry %cc %home /[from]/[to])
      ?.  ?=([~ ~ %tube *] tub)  ~
      `!<(tube:clay q.u.u.tub)
    ::
    ++  do-scry
      |=  [care=term =desk =path]
      ^-  (unit (unit cage))
      (scry [%141 %noun] ~ care [our desk da+now] (flop path))
    ::
    ++  error-response
      |=  [status=@ud =tape]
      ^-  (quip move server-state)
      %^  return-static-data-on-duct  status  'text/html'
      (error-page status authenticated url.request tape)
    --
  ::  +subscribe-to-app: subscribe to app and poke it with request data
  ::
  ++  subscribe-to-app
    |=  [app=term =inbound-request:eyre]
    ^-  (list move)
    :~  :*  duct  %pass  /watch-response/[eyre-id]
            %g  %deal  [our our]  app
            %watch  /http-response/[eyre-id]
        ==
      ::
        :*  duct  %pass  /run-app-request/[eyre-id]
            %g  %deal  [our our]  app
            %poke  %handle-http-request
            !>([eyre-id inbound-request])
        ==
    ==
  ::  +cancel-request: handles a request being externally aborted
  ::
  ++  cancel-request
    ^-  [(list move) server-state]
    ::
    ?~  connection=(~(get by connections.state) duct)
      ::  nothing has handled this connection
      ::
      [~ state]
    ::
    =.   connections.state  (~(del by connections.state) duct)
    ::
    ?-    -.action.u.connection
        %gen  [~ state]
        %app
      :_  state
      :_  ~
      :*  duct  %pass  /watch-response/[eyre-id]
          %g  %deal  [our our]  app.action.u.connection
          %leave  ~
      ==
    ::
        ?(%authentication %logout)
      [~ state]
    ::
        %channel
      on-cancel-request:by-channel
    ::
        ?(%scry %four-oh-four)
      ::  it should be impossible for a scry or 404 page to be asynchronous
      ::
      !!
    ==
  ::  +return-static-data-on-duct: returns one piece of data all at once
  ::
  ++  return-static-data-on-duct
    |=  [code=@ content-type=@t data=octs]
    ^-  [(list move) server-state]
    ::
    %-  handle-response
    :*  %start
        :-  status-code=code
        ^=  headers
          :~  ['content-type' content-type]
              ['content-length' (crip (format-ud-as-integer p.data))]
          ==
        data=[~ data]
        complete=%.y
    ==
  ::  +authentication: per-event authentication as this Urbit's owner
  ::
  ::    Right now this hard codes the authentication page using the old +code
  ::    system, but in the future should be pluggable so we can use U2F or
  ::    WebAuthn or whatever is more secure than passwords.
  ::
  ++  authentication
    |%
    ::  +handle-request: handles an http request for the login page
    ::
    ++  handle-request
      |=  [secure=? =address =request:http]
      ^-  [(list move) server-state]
      ::
      ::  if we received a simple get, just return the page
      ::
      ?:  =('GET' method.request)
        ::  parse the arguments out of request uri
        ::
        =+  request-line=(parse-request-line url.request)
        %^  return-static-data-on-duct  200  'text/html'
        (login-page (get-header:http 'redirect' args.request-line) our)
      ::  if we are not a post, return an error
      ::
      ?.  =('POST' method.request)
        (return-static-data-on-duct 400 'text/html' (login-page ~ our))
      ::  we are a post, and must process the body type as form data
      ::
      ?~  body.request
        (return-static-data-on-duct 400 'text/html' (login-page ~ our))
      ::
      =/  parsed=(unit (list [key=@t value=@t]))
        (rush q.u.body.request yquy:de-purl:html)
      ?~  parsed
        (return-static-data-on-duct 400 'text/html' (login-page ~ our))
      ::
      =/  redirect=(unit @t)  (get-header:http 'redirect' u.parsed)
      ?~  password=(get-header:http 'password' u.parsed)
        (return-static-data-on-duct 400 'text/html' (login-page redirect our))
      ::  check that the password is correct
      ::
      ?.  =(u.password code)
        (return-static-data-on-duct 400 'text/html' (login-page redirect our))
      ::  mint a unique session cookie
      ::
      =/  session=@uv
        |-
        =/  candidate=@uv  (~(raw og eny) 128)
        ?.  (~(has by sessions.authentication-state.state) candidate)
          candidate
        $(eny (shas %try-again candidate))
      ::  record cookie and record expiry time
      ::
      =/  first-session=?  =(~ sessions.authentication-state.state)
      =/  expires-at=@da   (add now session-timeout)
      =.  sessions.authentication-state.state
        (~(put by sessions.authentication-state.state) session [expires-at ~])
      ::
      =/  cookie-line=@t
        (session-cookie-string session &)
      ::
      =;  out=[moves=(list move) server-state]
        ::  if we didn't have any cookies previously, start the expiry timer
        ::
        ?.  first-session  out
        =-  out(moves [- moves.out])
        [duct %pass /sessions/expire %b %wait expires-at]
      ::
      ?~  redirect
        %-  handle-response
        :*  %start
            :-  status-code=200
            ^=  headers
              :~  ['set-cookie' cookie-line]
              ==
            data=~
            complete=%.y
        ==
      ::
      =/  actual-redirect  ?:(=(u.redirect '') '/' u.redirect)
      %-  handle-response
      :*  %start
          :-  status-code=303
          ^=  headers
            :~  ['location' actual-redirect]
                ['set-cookie' cookie-line]
            ==
          data=~
          complete=%.y
      ==
    ::  +handle-logout: handles an http request for logging out
    ::
    ++  handle-logout
      |=  [authenticated=? =request:http]
      ^-  [(list move) server-state]
      ::  whatever we end up doing, we always redirect to the login page
      ::
      =/  response=$>(%start http-event:http)
        :*  %start
            response-header=[303 ['location' '/~/login']~]
            data=~
            complete=%.y
        ==
      ::
      =/  session-id=(unit @uv)
        (session-id-from-request request)
      =?  headers.response-header.response  ?=(^ session-id)
        :_  headers.response-header.response
        ['set-cookie' (session-cookie-string u.session-id |)]
      ?.  &(authenticated ?=(^ session-id))
        (handle-response response)
      ::  delete the requesting session, or all sessions if so specified
      ::
      =^  channels=(list @t)  sessions.authentication-state.state
        =*  sessions  sessions.authentication-state.state
        =/  all=?
          ?~  body.request  |
          =-  ?=(^ -)
          %+  get-header:http  'all'
          (fall (rush q.u.body.request yquy:de-purl:html) ~)
        ?.  all
          :_  (~(del by sessions) u.session-id)
          %~  tap  in
          channels:(~(gut by sessions) u.session-id *session)
        :_  ~
        %~  tap  in
        %+  roll  ~(val by sessions)
        |=  [session all=(set @t)]
        (~(uni in all) channels)
      ::  close all affected channels, then send the response
      ::
      =|  moves=(list move)
      |-  ^-  (quip move server-state)
      ?~  channels
        =^  moz  state
          (handle-response response)
        [(weld moves moz) state]
      =^  moz  state
        (discard-channel:by-channel i.channels |)
      $(moves (weld moves moz), channels t.channels)
    ::  +session-id-from-request: attempt to find a session cookie
    ::
    ++  session-id-from-request
      |=  =request:http
      ^-  (unit @uv)
      ::  are there cookies passed with this request?
      ::
      ::    TODO: In HTTP2, the client is allowed to put multiple 'Cookie'
      ::    headers.
      ::
      ?~  cookie-header=(get-header:http 'cookie' header-list.request)
        ~
      ::  is the cookie line is valid?
      ::
      ?~  cookies=(rush u.cookie-header cock:de-purl:html)
        ~
      ::  is there an urbauth cookie?
      ::
      ?~  urbauth=(get-header:http (crip "urbauth-{<our>}") u.cookies)
        ~
      ::  if it's formatted like a valid session cookie, produce it
      ::
      `(unit @)`(rush u.urbauth ;~(pfix (jest '0v') viz:ag))
    ::  +request-is-logged-in: checks to see if the request is authenticated
    ::
    ::    We are considered logged in if this request has an urbauth
    ::    Cookie which is not expired.
    ::
    ++  request-is-logged-in
      |=  =request:http
      ^-  ?
      ::  does the request pass a session cookie?
      ::
      ?~  session-id=(session-id-from-request request)
        %.n
      ::  is this a session that we know about?
      ::
      ?~  session=(~(get by sessions.authentication-state.state) `@uv`u.session-id)
        %.n
      ::  is this session still valid?
      ::
      (lte now expiry-time.u.session)
    ::  +code: returns the same as |code
    ::
    ++  code
      ^-  @ta
      ::
      =+  pax=/(scot %p our)/code/(scot %da now)/(scot %p our)
      =+  res=((sloy scry) [151 %noun] %j pax)
      ::
      (rsh 3 1 (scot %p (@ (need (need res)))))
    ::  +session-cookie-string: compose session cookie
    ::
    ++  session-cookie-string
      |=  [session=@uv extend=?]
      ^-  @t
      %-  crip
      =;  max-age=tape
        "urbauth-{<our>}={<session>}; Path=/; Max-Age={max-age}"
      %-  format-ud-as-integer
      ?.  extend  0
      (div (msec:milly session-timeout) 1.000)
    --
  ::  +channel: per-event handling of requests to the channel system
  ::
  ::    Eyre offers a remote interface to your Urbit through channels, which
  ::    are persistent connections on the server which can be disconnected and
  ::    reconnected on the client.
  ::
  ++  by-channel
    ::  moves: the moves to be sent out at the end of this event, reversed
    ::
    =|  moves=(list move)
    |%
    ::  +handle-request: handles an http request for the subscription system
    ::
    ++  handle-request
      |=  [secure=? authenticated=? =address =request:http]
      ^-  [(list move) server-state]
      ::  if we're not authenticated error, but don't redirect.
      ::
      ::    We don't redirect because subscription stuff is never the toplevel
      ::    page; issuing a redirect won't help.
      ::
      ?.  authenticated
        %^  return-static-data-on-duct  403  'text/html'
        (error-page 403 authenticated url.request "unauthenticated channel usage")
      ::  parse out the path key the subscription is on
      ::
      =+  request-line=(parse-request-line url.request)
      ?.  ?=([@t @t @t ~] site.request-line)
        ::  url is not of the form '/~/channel/'
        ::
        %^  return-static-data-on-duct  400  'text/html'
        (error-page 400 authenticated url.request "malformed channel url")
      ::  channel-id: unique channel id parsed out of url
      ::
      =+  channel-id=i.t.t.site.request-line
      ::
      ?:  =('PUT' method.request)
        ::  PUT methods starts/modifies a channel, and returns a result immediately
        ::
        (on-put-request channel-id request)
      ::
      ?:  =('GET' method.request)
        (on-get-request channel-id request)
      ?:  =('POST' method.request)
        ::  POST methods are used solely for deleting channels
        (on-put-request channel-id request)
      ::
      ~&  %session-not-a-put
      [~ state]
    ::  +on-cancel-request: cancels an ongoing subscription
    ::
    ::    One of our long lived sessions just got closed. We put the associated
    ::    session back into the waiting state.
    ::
    ++  on-cancel-request
      ^-  [(list move) server-state]
      ::  lookup the session id by duct
      ::
      ?~  maybe-channel-id=(~(get by duct-to-key.channel-state.state) duct)
        ~>  %slog.[0 leaf+"eyre: no channel to cancel {<duct>}"]
        [~ state]
      ::
      ~>  %slog.[0 leaf+"eyre: canceling {<duct>}"]
      ::
      =/  maybe-session
        (~(get by session.channel-state.state) u.maybe-channel-id)
      ?~  maybe-session  [~ state]
      ::
      =/  heartbeat-cancel=(list move)
        ?~  heartbeat.u.maybe-session  ~
        :~  %^  cancel-heartbeat-move
              u.maybe-channel-id
            date.u.heartbeat.u.maybe-session
          duct.u.heartbeat.u.maybe-session
        ==
      ::
      =/  expiration-time=@da  (add now channel-timeout)
      ::
      :-  %+  weld  heartbeat-cancel
        [(set-timeout-move u.maybe-channel-id expiration-time) moves]
      %_    state
          session.channel-state
        %+  ~(jab by session.channel-state.state)  u.maybe-channel-id
        |=  =channel
        ::  if we are canceling a known channel, it should have a listener
        ::
        ?>  ?=([%| *] state.channel)
        channel(state [%& [expiration-time duct]], heartbeat ~)
      ::
          duct-to-key.channel-state
        (~(del by duct-to-key.channel-state.state) duct)
      ==
    ::  +set-timeout-timer-for: sets a timeout timer on a channel
    ::
    ::    This creates a channel if it doesn't exist, cancels existing timers
    ::    if they're already set (we cannot have duplicate timers), and (if
    ::    necessary) moves channels from the listening state to the expiration
    ::    state.
    ::
    ++  update-timeout-timer-for
      |=  channel-id=@t
      ^+  ..update-timeout-timer-for
      ::  when our callback should fire
      ::
      =/  expiration-time=@da  (add now channel-timeout)
      ::  if the channel doesn't exist, create it and set a timer
      ::
      ?~  maybe-channel=(~(get by session.channel-state.state) channel-id)
        ::
        %_    ..update-timeout-timer-for
            session.channel-state.state
          %+  ~(put by session.channel-state.state)  channel-id
          [[%& expiration-time duct] 0 ~ ~ ~]
        ::
            moves
          [(set-timeout-move channel-id expiration-time) moves]
        ==
      ::  if the channel has an active listener, we aren't setting any timers
      ::
      ?:  ?=([%| *] state.u.maybe-channel)
        ..update-timeout-timer-for
      ::  we have a previous timer; cancel the old one and set the new one
      ::
      %_    ..update-timeout-timer-for
          session.channel-state.state
        %+  ~(jab by session.channel-state.state)  channel-id
        |=  =channel
        channel(state [%& [expiration-time duct]])
      ::
          moves
        :*  (cancel-timeout-move channel-id p.state.u.maybe-channel)
            (set-timeout-move channel-id expiration-time)
            moves
        ==
      ==
    ::
    ++  set-heartbeat-move
      |=  [channel-id=@t heartbeat-time=@da]
      ^-  move
      :^  duct  %pass  /channel/heartbeat/[channel-id]
      [%b %wait heartbeat-time]
    ::
    ++  cancel-heartbeat-move
      |=  [channel-id=@t heartbeat-time=@da =^duct]
      ^-  move
      :^  duct  %pass  /channel/heartbeat/[channel-id]
      [%b %rest heartbeat-time]
    ::
    ++  set-timeout-move
      |=  [channel-id=@t expiration-time=@da]
      ^-  move
      [duct %pass /channel/timeout/[channel-id] %b %wait expiration-time]
    ::
    ++  cancel-timeout-move
      |=  [channel-id=@t expiration-time=@da =^duct]
      ^-  move
      :^  duct  %pass  /channel/timeout/[channel-id]
      [%b %rest expiration-time]
    ::  +on-get-request: handles a GET request
    ::
    ::    GET requests open a channel for the server to send events to the
    ::    client in text/event-stream format.
    ::
    ++  on-get-request
      |=  [channel-id=@t =request:http]
      ^-  [(list move) server-state]
      ::  if there's no channel-id, we must 404
      ::
      ?~  maybe-channel=(~(get by session.channel-state.state) channel-id)
        %^  return-static-data-on-duct  404  'text/html'
        (error-page 404 %.y url.request ~)
      ::  if there's already a duct listening to this channel, we must 400
      ::
      ?:  ?=([%| *] state.u.maybe-channel)
        %^  return-static-data-on-duct  400  'text/html'
        (error-page 400 %.y url.request "channel already bound")
      ::  when opening an event-stream, we must cancel our timeout timer
      ::
      =.  moves
        [(cancel-timeout-move channel-id p.state.u.maybe-channel) moves]
      ::  the request may include a 'Last-Event-Id' header
      ::
      =/  maybe-last-event-id=(unit @ud)
        ?~  maybe-raw-header=(get-header:http 'Last-Event-ID' header-list.request)
          ~
        (rush u.maybe-raw-header dum:ag)
      ::  flush events older than the passed in 'Last-Event-ID'
      ::
      =?  state  ?=(^ maybe-last-event-id)
        (acknowledge-events channel-id u.maybe-last-event-id)
      ::  combine the remaining queued events to send to the client
      ::
      =/  event-replay=wall
        %-  zing
        %-  flop
        =/  queue  events.u.maybe-channel
        =|  events=(list wall)
        |-
        ^+  events
        ?:  =(~ queue)
          events
        =^  head  queue  ~(get to queue)
        $(events [lines.p.head events])
      ::  send the start event to the client
      ::
      =^  http-moves  state
        %-  handle-response
        :*  %start
            :-  200
            :~  ['content-type' 'text/event-stream']
                ['cache-control' 'no-cache']
                ['connection' 'keep-alive']
            ==
            (wall-to-octs event-replay)
            complete=%.n
        ==
      ::  associate this duct with this session key
      ::
      =.  duct-to-key.channel-state.state
        (~(put by duct-to-key.channel-state.state) duct channel-id)
      ::  associate this channel with the session cookie
      ::
      =.  sessions.authentication-state.state
        =/  session-id=(unit @uv)
          (session-id-from-request:authentication request)
        ?~  session-id  sessions.authentication-state.state
        %+  ~(jab by sessions.authentication-state.state)
          u.session-id
        |=  =session
        session(channels (~(put in channels.session) channel-id))
      ::  initialize sse heartbeat
      ::
      =/  heartbeat-time=@da  (add now ~s20)
      =/  heartbeat  (set-heartbeat-move channel-id heartbeat-time)
      ::  clear the event queue, record the duct for future output and
      ::  record heartbeat-time for possible future cancel
      ::
      =.  session.channel-state.state
        %+  ~(jab by session.channel-state.state)  channel-id
        |=  =channel
        channel(events ~, state [%| duct], heartbeat (some [heartbeat-time duct]))
      ::
      [[heartbeat (weld http-moves moves)] state]
    ::  +acknowledge-events: removes events before :last-event-id on :channel-id
    ::
    ++  acknowledge-events
      |=  [channel-id=@t last-event-id=@u]
      ^-  server-state
      %_    state
          session.channel-state
        %+  ~(jab by session.channel-state.state)  channel-id
        |=  =channel
        ^+  channel
        channel(events (prune-events events.channel last-event-id))
      ==
    ::  +on-put-request: handles a PUT request
    ::
    ::    PUT requests send commands from the client to the server. We receive
    ::    a set of commands in JSON format in the body of the message.
    ::
    ++  on-put-request
      |=  [channel-id=@t =request:http]
      ^-  [(list move) server-state]
      ::  error when there's no body
      ::
      ?~  body.request
        %^  return-static-data-on-duct  400  'text/html'
        (error-page 400 %.y url.request "no put body")
      ::  if the incoming body isn't json, this is a bad request, 400.
      ::
      ?~  maybe-json=(de-json:html q.u.body.request)
        %^  return-static-data-on-duct  400  'text/html'
        (error-page 400 %.y url.request "put body not json")
      ::  parse the json into an array of +channel-request items
      ::
      ?~  maybe-requests=(parse-channel-request u.maybe-json)
        %^  return-static-data-on-duct  400  'text/html'
        (error-page 400 %.y url.request "invalid channel json")
      ::  while weird, the request list could be empty
      ::
      ?:  =(~ u.maybe-requests)
        %^  return-static-data-on-duct  400  'text/html'
        (error-page 400 %.y url.request "empty list of actions")
      ::  check for the existence of the channel-id
      ::
      ::    if we have no session, create a new one set to expire in
      ::    :channel-timeout from now. if we have one which has a timer, update
      ::    that timer.
      ::
      =.  ..on-put-request  (update-timeout-timer-for channel-id)
      ::  for each request, execute the action passed in
      ::
      =+  requests=u.maybe-requests
      ::  gall-moves: put moves here first so we can flop for ordering
      ::
      ::    TODO: Have an error state where any invalid duplicate subscriptions
      ::    or other errors cause the entire thing to fail with a 400 and a tang.
      ::
      =|  gall-moves=(list move)
      |-
      ::
      ?~  requests
        ::  this is a PUT request; we must mark it as complete
        ::
        =^  http-moves  state
          %-  handle-response
          :*  %start
              [status-code=200 headers=~]
              data=~
              complete=%.y
          ==
        ::
        [:(weld (flop gall-moves) http-moves moves) state]
      ::
      ?-    -.i.requests
          %ack
        ::  client acknowledges that they have received up to event-id
        ::
        %_  $
          state     (acknowledge-events channel-id event-id.i.requests)
          requests  t.requests
        ==
      ::
          %poke
        ::
        =.  gall-moves
          :_  gall-moves
          ^-  move
          :^  duct  %pass  /channel/poke/[channel-id]/(scot %ud request-id.i.requests)
          =,  i.requests
          :*  %g  %deal  `sock`[our ship]  app
              `task:agent:gall`[%poke-as mark %json !>(json)]
          ==
        ::
        $(requests t.requests)
      ::
          %subscribe
        ::
        =/  channel-wire=wire
          /channel/subscription/[channel-id]/(scot %ud request-id.i.requests)
        ::
        =.  gall-moves
          :_  gall-moves
          ^-  move
          :^  duct  %pass  channel-wire
          =,  i.requests
          :*  %g  %deal  [our ship]  app
              `task:agent:gall`[%watch-as %json path]
          ==
        ::
        =.  session.channel-state.state
          %+  ~(jab by session.channel-state.state)  channel-id
          |=  =channel
          =,  i.requests
          channel(subscriptions (~(put by subscriptions.channel) channel-wire [ship app path duct]))
        ::
        $(requests t.requests)
      ::
          %unsubscribe
        =/  channel-wire=wire
          /channel/subscription/[channel-id]/(scot %ud subscription-id.i.requests)
        ::
        =/  usession  (~(get by session.channel-state.state) channel-id)
        ?~  usession
          $(requests t.requests)
        =/  subscriptions  subscriptions:u.usession
        ::
        ?~  maybe-subscription=(~(get by subscriptions) channel-wire)
          ::  the client sent us a weird request referring to a subscription
          ::  which isn't active.
          ::
          ~&  [%missing-subscription-in-unsubscribe channel-wire]
          $(requests t.requests)
        ::
        =.  gall-moves
          :_  gall-moves
          ^-  move
          :^  duc.u.maybe-subscription  %pass  channel-wire
          =,  u.maybe-subscription
          :*  %g  %deal  [our ship]  app
              `task:agent:gall`[%leave ~]
          ==
        ::
        =.  session.channel-state.state
          %+  ~(jab by session.channel-state.state)  channel-id
          |=  =channel
          channel(subscriptions (~(del by subscriptions.channel) channel-wire))
        ::
        $(requests t.requests)
      ::
          %delete
        =^  moves  state
          (discard-channel channel-id |)
        =.  gall-moves
          (weld gall-moves moves)
        $(requests t.requests)
      ::
      ==
    ::  +on-gall-response: turns a gall response into an event
    ::
    ++  on-gall-response
      |=  [channel-id=@t request-id=@ud =sign:agent:gall]
      ^-  [(list move) server-state]
      ::
      ?-    -.sign
          %poke-ack
        =/  =json
          =,  enjs:format
          %-  pairs  :~
            ['response' [%s 'poke']]
            ['id' (numb request-id)]
            ?~  p.sign
              ['ok' [%s 'ok']]
            ['err' (wall (render-tang-to-wall 100 u.p.sign))]
          ==
        ::
        (emit-event channel-id [(en-json:html json)]~)
      ::
          %fact
        =/  =json
          =,  enjs:format
          %-  pairs  :~
            ['response' [%s 'diff']]
            ['id' (numb request-id)]
            :-  'json'
            ?>  =(%json p.cage.sign)
            ;;(json q.q.cage.sign)
          ==
        ::
        (emit-event channel-id [(en-json:html json)]~)
      ::
          %kick
        =/  =json
          =,  enjs:format
          %-  pairs  :~
            ['response' [%s 'quit']]
            ['id' (numb request-id)]
          ==
        ::
        (emit-event channel-id [(en-json:html json)]~)
      ::
          %watch-ack
        =/  =json
          =,  enjs:format
          %-  pairs  :~
            ['response' [%s 'subscribe']]
            ['id' (numb request-id)]
            ?~  p.sign
              ['ok' [%s 'ok']]
            ['err' (wall (render-tang-to-wall 100 u.p.sign))]
          ==
        ::
        (emit-event channel-id [(en-json:html json)]~)
      ==
    ::  +emit-event: records an event occurred, possibly sending to client
    ::
    ::    When an event occurs, we need to record it, even if we immediately
    ::    send it to a connected browser so in case of disconnection, we can
    ::    resend it.
    ::
    ::    This function is responsible for taking the raw json lines and
    ::    converting them into a text/event-stream. The :event-stream-lines
    ::    then may get sent, and are stored for later resending until
    ::    acknowledged by the client.
    ::
    ++  emit-event
      |=  [channel-id=@t json-text=wall]
      ^-  [(list move) server-state]
      ::
      =/  channel=(unit channel)
        (~(get by session.channel-state.state) channel-id)
      ?~  channel
        :_  state  :_  ~
        [duct %pass /flog %d %flog %crud %eyre-no-channel >id=channel-id< ~]
      ::
      =/  event-id  next-id.u.channel
      ::
      =/  event-stream-lines=wall
        %-  weld  :_  [""]~
        :-  (weld "id: " (format-ud-as-integer event-id))
        %+  turn  json-text
        |=  =tape
        (weld "data: " tape)
      ::  if a client is connected, send this event to them.
      ::
      =?  moves  ?=([%| *] state.u.channel)
        ^-  (list move)
        :_  moves
        :+  p.state.u.channel  %give
        ^-  gift:able
        :*  %response  %continue
        ::
            ^=  data
            :-  ~
            %-  as-octs:mimes:html
            (crip (of-wall:format event-stream-lines))
        ::
            complete=%.n
        ==
      ::
      :-  moves
      %_    state
          session.channel-state
        %+  ~(jab by session.channel-state.state)  channel-id
        |=  =^channel
        ^+  channel
        ::
        %_  channel
          next-id  +(next-id.channel)
          events  (~(put to events.channel) [event-id event-stream-lines])
        ==
      ==
    ::
    ++  on-channel-heartbeat
      |=  channel-id=@t
      ^-  [(list move) server-state]
      ::
      ?~  connection-state=(~(get by connections.state) duct)
        [~ state]
      ::
      =/  res
        %-  handle-response
        :*  %continue
            data=(some (as-octs:mimes:html '\0a'))
            complete=%.n
        ==
      =/  http-moves  -.res
      =/  new-state  +.res
      =/  heartbeat-time=@da  (add now ~s20)
      :_  %_    new-state
              session.channel-state
            %+  ~(jab by session.channel-state.state)  channel-id
            |=  =channel
            channel(heartbeat (some [heartbeat-time duct]))
          ==
      (snoc http-moves (set-heartbeat-move channel-id heartbeat-time))
    ::  +discard-channel: remove a channel from state
    ::
    ::    cleans up state, timers, and gall subscriptions of the channel
    ::
    ++  discard-channel
      |=  [channel-id=@t expired=?]
      ^-  [(list move) server-state]
      ::
      =/  usession=(unit channel)
        (~(get by session.channel-state.state) channel-id)
      ?~  usession
        [~ state]
      =/  session=channel  u.usession
      ::
      :_  %_    state
              session.channel-state
            (~(del by session.channel-state.state) channel-id)
          ::
              duct-to-key.channel-state
            ?.  ?=(%| -.state.session)  duct-to-key.channel-state.state
            (~(del by duct-to-key.channel-state.state) p.state.session)
          ==
      =/  heartbeat-cancel=(list move)
        ?~  heartbeat.session  ~
        :~  %^  cancel-heartbeat-move
              channel-id
            date.u.heartbeat.session
          duct.u.heartbeat.session
        ==
      =/  expire-cancel=(list move)
        ?:  expired  ~
        ?.  ?=(%& -.state.session)  ~
        =,  p.state.session
        [(cancel-timeout-move channel-id date duct)]~
      %+  weld  heartbeat-cancel
      %+  weld  expire-cancel
      ::  produce a list of moves which cancels every gall subscription
      ::
      %+  turn  ~(tap by subscriptions.session)
      |=  [channel-wire=wire ship=@p app=term =path duc=^duct]
      ^-  move
      ::
      [duc %pass channel-wire [%g %deal [our ship] app %leave ~]]
    --
  ::  +handle-gall-error: a call to +poke-http-response resulted in a %coup
  ::
  ++  handle-gall-error
    |=  =tang
    ^-  [(list move) server-state]
    ::
    =+  connection=(~(got by connections.state) duct)
    =/  moves-1=(list move)
      ?.  ?=(%app -.action.connection)
        ~
      :_  ~
      :*  duct  %pass  /watch-response/[eyre-id]
          %g  %deal  [our our]  app.action.connection
          %leave  ~
      ==
    ::
    =^  moves-2  state
      %^  return-static-data-on-duct  500  'text/html'
      ::
      %-  internal-server-error  :*
          authenticated.inbound-request.connection
          url.request.inbound-request.connection
          tang
      ==
    [(weld moves-1 moves-2) state]
  ::  +handle-response: check a response for correctness and send to earth
  ::
  ::    All outbound responses including %http-server generated responses need to go
  ::    through this interface because we want to have one centralized place
  ::    where we perform logging and state cleanup for connections that we're
  ::    done with.
  ::
  ++  handle-response
    |=  =http-event:http
    ^-  [(list move) server-state]
    ::  verify that this is a valid response on the duct
    ::
    ?~  connection-state=(~(get by connections.state) duct)
      ~&  [%invalid-outstanding-connection duct]
      [~ state]
    ::
    |^  ^-  [(list move) server-state]
        ::
        ?-    -.http-event
        ::
            %start
          ?^  response-header.u.connection-state
            ~&  [%http-multiple-start duct]
            error-connection
          ::  if request was authenticated, extend the session & cookie's life
          ::
          =^  response-header  sessions.authentication-state.state
            =,  authentication
            =*  sessions  sessions.authentication-state.state
            =*  inbound   inbound-request.u.connection-state
            =*  no-op     [response-header.http-event sessions]
            ::
            ?.  authenticated.inbound
              no-op
            ?~  session-id=(session-id-from-request request.inbound)
              ::  cookies are the only auth method, so this is unexpected
              ::
              ~&  [%e %authenticated-without-cookie]
              no-op
            ?.  (~(has by sessions) u.session-id)
              ::  if the session has expired since the request was opened,
              ::  tough luck, we don't create/revive sessions here
              ::
              no-op
            :_  %+  ~(jab by sessions)  u.session-id
                |=  =session
                session(expiry-time (add now session-timeout))
            =-  response-header.http-event(headers -)
            %^  set-header:http  'set-cookie'
              (session-cookie-string u.session-id &)
            headers.response-header.http-event
          ::
          =.  response-header.http-event  response-header
          =.  connections.state
            %+  ~(jab by connections.state)  duct
            |=  connection=outstanding-connection
            %_  connection
              response-header  `response-header
              bytes-sent  ?~(data.http-event 0 p.u.data.http-event)
            ==
          ::
          =?  state  complete.http-event
            log-complete-request
          ::
          pass-response
        ::
            %continue
          ?~  response-header.u.connection-state
            ~&  [%http-continue-without-start duct]
            error-connection
          ::
          =.  connections.state
            %+  ~(jab by connections.state)  duct
            |=  connection=outstanding-connection
            =+  size=?~(data.http-event 0 p.u.data.http-event)
            connection(bytes-sent (add bytes-sent.connection size))
          ::
          =?  state  complete.http-event
            log-complete-request
          ::
          pass-response
        ::
            %cancel
          ::  todo: log this differently from an ise.
          ::
          error-connection
        ==
    ::
    ++  pass-response
      ^-  [(list move) server-state]
      [[duct %give %response http-event]~ state]
    ::
    ++  log-complete-request
      ::  todo: log the complete request
      ::
      ::  remove all outstanding state for this connection
      ::
      =.  connections.state
        (~(del by connections.state) duct)
      state
    ::
    ++  error-connection
      ::  todo: log application error
      ::
      ::  remove all outstanding state for this connection
      ::
      =.  connections.state
        (~(del by connections.state) duct)
      ::  respond to outside with %error
      ::
      ^-  [(list move) server-state]
      :_  state
      :-  [duct %give %response %cancel ~]
      ?.  ?=(%app -.action.u.connection-state)
        ~
      :_  ~
      :*  duct  %pass  /watch-response/[eyre-id]
          %g  %deal  [our our]  app.action.u.connection-state
          %leave  ~
      ==
    --
  ::  +add-binding: conditionally add a pairing between binding and action
  ::
  ::    Adds =binding =action if there is no conflicting bindings.
  ::
  ++  add-binding
    |=  [=binding =action]
    ^-  [(list move) server-state]
    =^  success  bindings.state
      (insert-binding [binding duct action] bindings.state)
    :_  state
    [duct %give %bound success binding]~
  ::  +remove-binding: removes a binding if it exists and is owned by this duct
  ::
  ++  remove-binding
    |=  =binding
    ::
    ^-  server-state
    %_    state
        bindings
      %+  skip  bindings.state
      |=  [item-binding=^binding item-duct=^duct =action]
      ^-  ?
      &(=(item-binding binding) =(item-duct duct))
    ==
  ::  +get-action-for-binding: finds an action for an incoming web request
  ::
  ++  get-action-for-binding
    |=  [raw-host=(unit @t) url=@t]
    ^-  [=action suburl=@t]
    ::  process :raw-host
    ::
    ::    If we are missing a 'Host:' header, if that header is a raw IP
    ::    address, or if the 'Host:' header refers to [our].urbit.org, we want
    ::    to return ~ which means we're unidentified and will match against any
    ::    wildcard matching.
    ::
    ::    Otherwise, return the site given.
    ::
    =/  host=(unit @t)
      ?~  raw-host
        ~
      ::  Parse the raw-host so that we can ignore ports, usernames, etc.
      ::
      =+  parsed=(rush u.raw-host simplified-url-parser)
      ?~  parsed
        ~
      ::  if the url is a raw IP, assume default site.
      ::
      ?:  ?=([%ip *] -.u.parsed)
        ~
      ::  if the url is "localhost", assume default site.
      ::
      ?:  =([%site 'localhost'] -.u.parsed)
        ~
      ::  render our as a tape, and cut off the sig in front.
      ::
      =/  with-sig=tape  (scow %p our)
      ?>  ?=(^ with-sig)
      ?:  =(u.raw-host (crip t.with-sig))
        ::  [our].urbit.org is the default site
        ::
        ~
      ::
      raw-host
    ::  url is the raw thing passed over the 'Request-Line'.
    ::
    ::    todo: this is really input validation, and we should return a 500 to
    ::    the client.
    ::
    =/  request-line  (parse-request-line url)
    =/  parsed-url=(list @t)  site.request-line
    ::
    =/  bindings  bindings.state
    |-
    ::
    ?~  bindings
      [[%four-oh-four ~] url]
    ::
    ?.  (host-matches site.binding.i.bindings raw-host)
      $(bindings t.bindings)
    ?~  suffix=(find-suffix path.binding.i.bindings parsed-url)
      $(bindings t.bindings)
    ::
    :-  action.i.bindings
    %^  cat  3
      %+  roll
        ^-  (list @t)
        (join '/' (flop ['' u.suffix]))
      (cury cat 3)
    ?~  ext.request-line  ''
    (cat 3 '.' u.ext.request-line)
  --
::
++  forwarded-for
  |=  =header-list:http
  ^-  (unit address)
  =/  forwarded=(unit @t)
    (get-header:http 'forwarded' header-list)
  ?~  forwarded  ~
  |^  =/  forwards=(unit (list (map @t @t)))
        (unpack-header:http u.forwarded)
      ?.  ?=([~ ^] forwards)  ~
      =*  forward  i.u.forwards
      ?~  for=(~(get by forward) 'for')  ~
      ::NOTE  per rfc7239, non-ip values are also valid. they're not useful
      ::      for the general case, so we ignore them here. if needed,
      ::      request handlers are free to inspect the headers themselves.
      ::
      (rush u.for ip-address)
  ::
  ++  ip-address
    ;~  sfix
      ;~(pose (stag %ipv4 ip4) (stag %ipv6 (ifix [lac rac] ip6)))
      ;~(pose ;~(pfix col dim:ag) (easy ~))
    ==
  --
::
++  parse-request-line
  |=  url=@t
  ^-  [[ext=(unit @ta) site=(list @t)] args=(list [key=@t value=@t])]
  (fall (rush url ;~(plug apat:de-purl:html yque:de-purl:html)) [[~ ~] ~])
::
++  insert-binding
  |=  [[=binding =duct =action] bindings=(list [=binding =duct =action])]
  =/  to-search  bindings
  |-  ^-  [? _bindings]
  ?^  to-search
    ?:  =(binding binding.i.to-search)
      [| bindings]
    ::
    $(to-search t.to-search)
  :-  &
  ::  store in reverse alphabetical order so that longer paths are first
  ::
  %-  flop
  %+  sort  [[binding duct action] bindings]
  |=  [[a=^binding *] [b=^binding *]]
  ::
  ?:  =(site.a site.b)
    (aor path.a path.b)
  ::  alphabetize based on site
  ::
  (aor ?~(site.a '' u.site.a) ?~(site.b '' u.site.b))
--
::  end the =~
::
.  ==
::  begin with a default +axle as a blank slate
::
=|  ax=axle
::  a vane is activated with current date, entropy, and a namespace function
::
|=  [our=ship now=@da eny=@uvJ scry-gate=sley]
::  allow jets to be registered within this core
::
~%  %http-server  ..is  ~
|%
++  call
  |=  [=duct dud=(unit goof) type=* wrapped-task=(hobo task:able)]
  ^-  [(list move) _http-server-gate]
  ::
  =/  task=task:able  ((harden task:able) wrapped-task)
  ::
  ::  error notifications "downcast" to %crud
  ::
  =?  task  ?=(^ dud)
    ~|  %crud-in-crud
    ?<  ?=(%crud -.task)
    [%crud -.task tang.u.dud]
  ::
  ::  %crud: notifies us of an event failure
  ::
  ?:  ?=(%crud -.task)
    =/  moves=(list move)
      [[duct %slip %d %flog task] ~]
    [moves http-server-gate]
  ::  %init: tells us what our ship name is
  ::
  ?:  ?=(%init -.task)
    ::  initial value for the login handler
    ::
    =.  bindings.server-state.ax
      :~  [[~ /~/login] duct [%authentication ~]]
          [[~ /~/logout] duct [%logout ~]]
          [[~ /~/channel] duct [%channel ~]]
          [[~ /~/scry] duct [%scry ~]]
      ==
    [~ http-server-gate]
  ::  %trim: in response to memory pressure
  ::
  ::    Cancel all inactive channels
  ::    XX cancel active too if =(0 trim-priority) ?
  ::
  ?:  ?=(%trim -.task)
    =/  event-args  [[our eny duct now scry-gate] server-state.ax]
    =*  by-channel  by-channel:(per-server-event event-args)
    =*  channel-state  channel-state.server-state.ax
    ::
    =/  inactive=(list @t)
      =/  full=(set @t)  ~(key by session.channel-state)
      =/  live=(set @t)
        (~(gas in *(set @t)) ~(val by duct-to-key.channel-state))
      ~(tap in (~(dif in full) live))
    ::
    ?:  =(~ inactive)
      [~ http-server-gate]
    ::
    =/  len=tape  (scow %ud (lent inactive))
    ~>  %slog.[0 leaf+"eyre: trim: closing {len} inactive channels"]
    ::
    =|  moves=(list (list move))
    |-  ^-  [(list move) _http-server-gate]
    =*  channel-id  i.inactive
    ?~  inactive
      [(zing (flop moves)) http-server-gate]
    ::  discard channel state, and cancel any active gall subscriptions
    ::
    =^  mov  server-state.ax  (discard-channel:by-channel channel-id |)
    $(moves [mov moves], inactive t.inactive)
  ::
  ::  %vega: notifies us of a completed kernel upgrade
  ::
  ?:  ?=(%vega -.task)
    [~ http-server-gate]
  ::  %born: new unix process
  ::
  ?:  ?=(%born -.task)
    ::  close previously open connections
    ::
    ::    When we have a new unix process, every outstanding open connection is
    ::    dead. For every duct, send an implicit close connection.
    ::
    =^  closed-connections=(list move)  server-state.ax
      =/  connections=(list [=^duct *])
        ~(tap by connections.server-state.ax)
      ::
      =|  closed-connections=(list move)
      |-
      ?~  connections
        [closed-connections server-state.ax]
      ::
      =/  event-args
        [[our eny duct.i.connections now scry-gate] server-state.ax]
      =/  cancel-request  cancel-request:(per-server-event event-args)
      =^  moves  server-state.ax  cancel-request
      ::
      $(closed-connections (weld moves closed-connections), connections t.connections)
    ::  save duct for future %give to unix
    ::
    =.  outgoing-duct.server-state.ax  duct
    ::
    :_  http-server-gate
    ;:  weld
      ::  hand back default configuration for now
      ::
      [duct %give %set-config http-config.server-state.ax]~
    ::
      closed-connections
    ==
  ::  all other commands operate on a per-server-event
  ::
  =/  event-args  [[our eny duct now scry-gate] server-state.ax]
  =/  server  (per-server-event event-args)
  ::
  ?-    -.task
      ::  %live: notifies us of the ports of our live http servers
      ::
      %live
    =.  ports.server-state.ax  +.task
    [~ http-server-gate]
      ::  %rule: updates our http configuration
      ::
      %rule
    ?-  -.http-rule.task
        ::  %cert: install tls certificate
        ::
        %cert
      =*  config  http-config.server-state.ax
      ?:  =(secure.config cert.http-rule.task)
        [~ http-server-gate]
      =.  secure.config  cert.http-rule.task
      :_  http-server-gate
      =*  out-duct  outgoing-duct.server-state.ax
      ?~  out-duct  ~
      [out-duct %give %set-config config]~
        ::  %turf: add or remove domain name
        ::
        %turf
      =*  domains  domains.server-state.ax
      =/  mod/(set turf)
        ?:  ?=(%put action.http-rule.task)
          (~(put in domains) turf.http-rule.task)
        (~(del in domains) turf.http-rule.task)
      ?:  =(domains mod)
        [~ http-server-gate]
      =.  domains  mod
      :_  http-server-gate
      =/  cmd
        [%acme %poke `cage`[%acme-order !>(mod)]]
      [duct %pass /acme/order %g %deal [our our] cmd]~
    ==
  ::
      %request
    =^  moves  server-state.ax  (request:server +.task)
    [moves http-server-gate]
  ::
      %request-local
    =^  moves  server-state.ax  (request-local:server +.task)
    [moves http-server-gate]
  ::
      %cancel-request
    =^  moves  server-state.ax  cancel-request:server
    [moves http-server-gate]
  ::
      %connect
    =^  moves  server-state.ax
      %+  add-binding:server  binding.task
      [%app app.task]
    [moves http-server-gate]
  ::
      %serve
    =^  moves  server-state.ax
      %+  add-binding:server  binding.task
      [%gen generator.task]
    [moves http-server-gate]
  ::
      %disconnect
    =.  server-state.ax  (remove-binding:server binding.task)
    [~ http-server-gate]
  ==
::
++  take
  |=  [=wire =duct dud=(unit goof) wrapped-sign=(hypo sign)]
  ^-  [(list move) _http-server-gate]
  ?^  dud
    ~|(%eyre-take-dud (mean tang.u.dud))
  ::  unwrap :sign, ignoring unneeded +type in :p.wrapped-sign
  ::
  =/  =sign  q.wrapped-sign
  =>  %=    .
          sign
        ?:  ?=(%g -.sign)
          ?>  ?=(%unto +<.sign)
          sign
        sign
      ==
  ::  :wire must at least contain two parts, the type and the build
  ::
  ?>  ?=([@ *] wire)
  ::
  |^  ^-  [(list move) _http-server-gate]
      ::
      ?+     i.wire
           ~|([%bad-take-wire wire] !!)
      ::
         %run-app-request  run-app-request
         %watch-response   watch-response
         %sessions         sessions
         %channel          channel
         %acme             acme-ack
      ==
  ::
  ++  run-app-request
    ::
    ?>  ?=([%g %unto *] sign)
    ::
    ::
    ?>  ?=([%poke-ack *] p.sign)
    ?>  ?=([@ *] t.wire)
    ?~  p.p.sign
      ::  received a positive acknowledgment: take no action
      ::
      [~ http-server-gate]
    ::  we have an error; propagate it to the client
    ::
    =/  event-args  [[our eny duct now scry-gate] server-state.ax]
    =/  handle-gall-error
      handle-gall-error:(per-server-event event-args)
    =^  moves  server-state.ax
      (handle-gall-error u.p.p.sign)
    [moves http-server-gate]
  ::
  ++  watch-response
    ::
    =/  event-args  [[our eny duct now scry-gate] server-state.ax]
    ::
    ?>  ?=([@ *] t.wire)
    ?:  ?=([%g %unto %watch-ack *] sign)
      ?~  p.p.sign
        ::  received a positive acknowledgment: take no action
        ::
        [~ http-server-gate]
      ::  we have an error; propagate it to the client
      ::
      =/  handle-gall-error
        handle-gall-error:(per-server-event event-args)
      =^  moves  server-state.ax  (handle-gall-error u.p.p.sign)
      [moves http-server-gate]
    ::
    ?:  ?=([%g %unto %kick ~] sign)
      =/  handle-response  handle-response:(per-server-event event-args)
      =^  moves  server-state.ax
        (handle-response %continue ~ &)
      [moves http-server-gate]
    ::
    ?>  ?=([%g %unto %fact *] sign)
    =/  =mark  p.cage.p.sign
    =/  =vase  q.cage.p.sign
    ?.  ?=  ?(%http-response-header %http-response-data %http-response-cancel)
        mark
      =/  handle-gall-error
        handle-gall-error:(per-server-event event-args)
      =^  moves  server-state.ax
        (handle-gall-error leaf+"eyre bad mark {<mark>}" ~)
      [moves http-server-gate]
    ::
    =/  =http-event:http
      ?-  mark
        %http-response-header  [%start !<(response-header:http vase) ~ |]
        %http-response-data    [%continue !<((unit octs) vase) |]
        %http-response-cancel  [%cancel ~]
      ==
    =/  handle-response  handle-response:(per-server-event event-args)
    =^  moves  server-state.ax
      (handle-response http-event)
    [moves http-server-gate]
  ::
  ++  channel
    ::
    =/  event-args  [[our eny duct now scry-gate] server-state.ax]
    ::  channel callback wires are triples.
    ::
    ?>  ?=([@ @ @t *] wire)
    ::
    ?+    i.t.wire
        ~|([%bad-channel-wire wire] !!)
    ::
        %timeout
      ?>  ?=([%b %wake *] sign)
      ?^  error.sign
        [[duct %slip %d %flog %crud %wake u.error.sign]~ http-server-gate]
      =/  discard-channel
        discard-channel:by-channel:(per-server-event event-args)
      =^  moves  server-state.ax
        (discard-channel i.t.t.wire &)
      [moves http-server-gate]
    ::
        %heartbeat
      =/  on-channel-heartbeat
        on-channel-heartbeat:by-channel:(per-server-event event-args)
      =^  moves  server-state.ax
        (on-channel-heartbeat i.t.t.wire)
      [moves http-server-gate]
    ::
        ?(%poke %subscription)
      ?>  ?=([%g %unto *] sign)
      ?>  ?=([@ @ @t @ *] wire)
      =/  on-gall-response
        on-gall-response:by-channel:(per-server-event event-args)
      ::  ~&  [%gall-response sign]
      =^  moves  server-state.ax
        (on-gall-response i.t.t.wire `@ud`(slav %ud i.t.t.t.wire) p.sign)
      [moves http-server-gate]
    ==
  ::
  ++  sessions
    ::
    ?>  ?=([%b %wake *] sign)
    ::
    ?^  error.sign
      [[duct %slip %d %flog %crud %wake u.error.sign]~ http-server-gate]
    ::  remove cookies that have expired
    ::
    =*  sessions  sessions.authentication-state.server-state.ax
    =.  sessions.authentication-state.server-state.ax
      %-  ~(gas by *(map @uv session))
      %+  skip  ~(tap in sessions)
      |=  [cookie=@uv session]
      (lth expiry-time now)
    ::  if there's any cookies left, set a timer for the next expected expiry
    ::
    ^-  [(list move) _http-server-gate]
    :_  http-server-gate
    ?:  =(~ sessions)  ~
    =;  next-expiry=@da
      [duct %pass /sessions/expire %b %wait next-expiry]~
    %+  roll  ~(tap by sessions)
    |=  [[@uv session] next=@da]
    ?:  =(*@da next)  expiry-time
    (min next expiry-time)
  ::
  ++  acme-ack
    ?>  ?=([%g %unto *] sign)
    ::
    ?>  ?=([%poke-ack *] p.sign)
    ?~  p.p.sign
      ::  received a positive acknowledgment: take no action
      ::
      [~ http-server-gate]
    ::  received a negative acknowledgment: XX do something
    ::
    [((slog u.p.p.sign) ~) http-server-gate]
  --
::
++  http-server-gate  ..$
::  +load: migrate old state to new state (called on vane reload)
::
++  load
  =>  |%
      +$  axle-2019-10-6
        [date=%~2019.10.6 server-state=server-state-2019-10-6]
      ::
      +$  server-state-2019-10-6
        $:  bindings=(list [=binding =duct =action])
            connections=(map duct outstanding-connection)
            authentication-state=sessions=(map @uv @da)
            =channel-state
            domains=(set turf)
            =http-config
            ports=[insecure=@ud secure=(unit @ud)]
            outgoing-duct=duct
        ==
      --
  |=  old=$%(axle axle-2019-10-6)
  ^+  ..^$
  ::
  ~!  %loading
  ?-  -.old
    %~2020.5.29  ..^$(ax old)
  ::
      %~2019.10.6
    =^  success  bindings.server-state.old
      %+  insert-binding
        [[~ /~/logout] [/e/load/logout]~ [%logout ~]]
      bindings.server-state.old
    ~?  !success  [%e %failed-to-setup-logout-endpoint]
    =^  success  bindings.server-state.old
      %+  insert-binding
        [[~ /~/scry] [/e/load/scry]~ [%scry ~]]
      bindings.server-state.old
    ~?  !success  [%e %failed-to-setup-scry-endpoint]
    %_  $
      date.old  %~2020.5.29
      sessions.authentication-state.server-state.old  ~
    ==
  ==
::  +stay: produce current state
::
++  stay  `axle`ax
::  +scry: request a path in the urbit namespace
::
++  scry
  |=  [fur=(unit (set monk)) ren=@tas why=shop syd=desk lot=coin tyl=path]
  ^-  (unit (unit cage))
  ?.  ?=(%& -.why)
    ~
  =*  who  p.why
  ?.  ?=(%$ ren)
    [~ ~]
  ?:  =(tyl /whey)
    =/  maz=(list mass)
      :~  bindings+&+bindings.server-state.ax
          auth+&+authentication-state.server-state.ax
          connections+&+connections.server-state.ax
          channels+&+channel-state.server-state.ax
          axle+&+ax
      ==
    ``mass+!>(maz)
  ?.  ?=(%$ -.lot)
    [~ ~]
  ?.  =(our who)
    ?.  =([%da now] p.lot)
      [~ ~]
    ~&  [%r %scry-foreign-host who]
    ~
  ?+  syd  [~ ~]
    %bindings              ``noun+!>(bindings.server-state.ax)
    %connections           ``noun+!>(connections.server-state.ax)
    %authentication-state  ``noun+!>(authentication-state.server-state.ax)
    %channel-state         ``noun+!>(channel-state.server-state.ax)
  ::
      %host
    %-  (lift (lift |=(a=hart:eyre [%hart !>(a)])))
    ^-  (unit (unit hart:eyre))
    =.  p.lot  ?.(=([%da now] p.lot) p.lot [%tas %real])
    ?+  p.lot
      [~ ~]
    ::
        [%tas %fake]
      ``[& [~ 8.443] %& /localhost]
    ::
        [%tas %real]
      =*  domains  domains.server-state.ax
      =*  ports  ports.server-state.ax
      =/  =host:eyre  [%& ?^(domains n.domains /localhost)]
      =/  secure=?  &(?=(^ secure.ports) !?=(hoke:eyre host))
      =/  port=(unit @ud)
        ?.  secure
          ?:(=(80 insecure.ports) ~ `insecure.ports)
        ?>  ?=(^ secure.ports)
        ?:(=(443 u.secure.ports) ~ secure.ports)
      ``[secure port host]
    ==
  ==
--
