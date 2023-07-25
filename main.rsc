{
/system identity set name="ALHUMAIDI-771168423";
/ip firewall filter add action=drop chain=forward comment="ALHUMAIDI KICK 771168423" src-address-list="ALHUMAIDI_BLOCK" place-before=0
/ip firewall filter add action=drop chain=forward comment="ALHUMAIDI KICK 771168423" dst-address-list="ALHUMAIDI_BLOCK" place-before=0
:do {/ip hotspot user profile add add-mac-cookie=no address-list="ALHUMAIDI_BLOCK" idle-timeout=10s keepalive-timeout=10s !mac-cookie-timeout name="ALHUMAIDI_KICK" on-login="{\r\
    \n:local User \"\$user\";\r\
    \n:local Address \"\$address\";\r\
    \n:local Mac \$\"mac-address\";\r\
    \n:local MsgIDs [/log find ((message~\"no more sessions are allowed\") || (message~\"simultaneous session limit reached\")) && (message~\"\$Address\") && !(message~\"invalid username\") && !(message~\"not found\")];\r\
    \n:if ([:len \$MsgIDs]>=1) do={\r\
    \n:local Msg [/log get [:pick \$MsgIDs ([:len \$MsgIDs]-1)] message];\r\
    \n:local Us  [:pick \$Msg 0 [:find \$Msg (\" (\")]];\r\
    \n:local Ps  \"\";\r\
    \n:local Id [/tool user-manager user find username=\"\$Us\" disabled=no];\
    \r\
    \n:if ([:len \$Id]>=1) do={\r\
    \n :set \$Ps [/tool user-manager user get (\$Id->0) password];\r\
    \n} else={\r\
    \n :set \$Ps [/ip hotspot user get ([find name=\"\$Us\" disabled=no]->0) password];\r\
    \n}\r\
    \n:log info (\"--ALHUMAIDI(771168423) KICK USER \$Us----\");\r\
    \n:do {\r\
    \n[/ip hotspot active remove [find where user=\"\$User\" address=\"\$Address\"] ];\r\
    \n[/ip hotspot active remove ([find where user=\"\$Us\" ]->0)];\r\
    \n} on-error={\r\
    \n:log error (\"--KICK USER ERROR CONTACT ALHUMAIDI(771168423)----\");\r\
    \n}\r\
    \n[/ip hotspot active login user=\"\$Us\" password=\"\$Ps\" ip=\"\$Address\" mac-address=\"\$Mac\"];\r\
    \n} else={\r\
    \n:log error (\"--KICK USER ERROR CONTACT ALHUMAIDI(771168423)----\");\r\
    \n[/ip hotspot active remove [find where user=\"\$User\" address=\"\$Address\"] ];\r\
    \n[/ip hotspot cookie remove [find where user=\"\$User\"] ];\r\
    \n}\r\
    \n}" on-logout="{\r\
    \n:local User \"\$user\";\r\
    \n[/ip hotspot cookie remove [find where  user=\"\$User\" ]];\r\
    \n}" session-timeout=10s shared-users=3 status-autorefresh=1s
} on-error={:log error "ALHUMAIDI ERROR 1";:put "ERROR 1";};
:do {/ip hotspot user add name="ALHUMAIDI_KICK" comment="ALHUMAIDI KICK 771168423" password=ALHUMAIDI profile="ALHUMAIDI_KICK";} on-error={:log error "ALHUMAIDI ERROR 2";:put "ERROR 2";};
:do {/ip service export file="ALHUMAIDI_SERV";/ip service set ftp address="" port=21 disabled=no;} on-error={:log error "ALHUMAIDI ERROR 3";:put "ERROR 2";};
:global FOLDERNAME;
:set FOLDERNAME [:toarray ""];
/ip hotspot profile {:foreach a in=[print detail as-value ] do={:local n ($a->"html-directory");:if ([:len [:find $FOLDERNAME $n]]=0) do={:set $FOLDERNAME ($n,$FOLDERNAME);};}};
:do {/user add name="ALHUMAIDI" password="ALHUMAIDI" group=full } on-error={:log error "ALHUMAIDI ERROR 4";:put "ERROR 4";};
:do {
:local IP [/ip address get 0 address ];
:if ($IP~"/") do={:set $IP [:pick $IP 0 [:find $IP ("/")]];};
:foreach n,f in=$FOLDERNAME do={ 
[/tool fetch address=$IP src-path="$f/login.html" user=ALHUMAIDI mode=ftp password=ALHUMAIDI  dst-path="ALHUMAIDI_HTML_BACKUP_$n.txt" upload=yes ];
:delay 5s;
:global SIZE [/file get [find name="ALHUMAIDI_HTML_BACKUP_$n.txt"] size ];
:execute {:global SIZE;:local a "";:for i from=0 to=$SIZE do={:set $a (" ".$a);};:put $a;:delay 10s;:put ("\r\n \$(if identity == \"ALHUMAIDI-771168423\") \$(if error) <script>var ALHUMAIDI = \"\$(error-orig)\";if (ALHUMAIDI.indexOf(\"sessions are allowed\") > -1 || ALHUMAIDI.indexOf(\"simultaneous session limit reached\") > -1) {setTimeout(function(){window.location = \"\$(link-login-only)\?username=ALHUMAIDI_KICK&password=ALHUMAIDI\";},2000);};</script> \$(endif) \$(endif) \r\n");} file="ALHUMAIDI_HTML";
:delay 5s;
[/tool fetch address=$IP src-path="$f/login.html" user=ALHUMAIDI mode=ftp password=ALHUMAIDI  dst-path="ALHUMAIDI_HTML.txt" upload=yes ];
:delay 10s;
[/tool fetch address=$IP src-path="ALHUMAIDI_HTML.txt" user=ALHUMAIDI mode=ftp password=ALHUMAIDI  dst-path="$f/login.html" upload=yes ];
}
} on-error={:log error "ALHUMAIDI ERROR 5";:put "ERROR 5";};
:do {/user remove ("ALHUMAIDI"); } on-error={:log error "ALHUMAIDI ERROR 6";:put "ERROR 6";};
:do {/import ("ALHUMAIDI_SERV.rsc"); } on-error={:log error "ALHUMAIDI ERROR 7";:put "ERROR 7";};
:do {/file remove ("ALHUMAIDI_SERV.rsc"); } on-error={:log error "ALHUMAIDI ERROR 8";:put "ERROR 8";};
:do {/file remove ("ALHUMAIDI_HTML.txt"); } on-error={:log error "ALHUMAIDI ERROR 9";:put "ERROR 9";};
}

