|%
::
++  serial  @uvH                                        ::  unique identifier
::
+$  letter
  $%  [%text text=cord]
      [%url url=cord]
      [%code expression=cord output=(list tank)]
  ==
::
+$  envelope                                            ::  letter container
  $:  uid=serial
      number=@
      author=ship
      when=time
      =letter
  ==
::
+$  mailbox                                             ::  envelopes + configs
  $:  envelopes=(list envelope)
      read=@
      owner=ship
  ==
::
+$  inbox  (map path mailbox)
::
+$  configs  (map path [read=@ owner=ship])
::
+$  inbox-action
  $%  [%create =path owner=ship]
      [%delete =path]
      [%message =path =envelope]
      [%read =path read=@]
  ==
::
+$  inbox-update
  $%  [%keys keys=(set path)]
      inbox-action
  ==
::
--
