{
/system identity set name="ALHUMAIDI-771168423";
/ip firewall filter add action=drop chain=forward comment="ALHUMAIDI KICK 771168423" src-address-list="ALHUMAIDI_BLOCK" place-before=0
/ip firewall filter add action=drop chain=forward comment="ALHUMAIDI KICK 771168423" dst-address-list="ALHUMAIDI_BLOCK" place-before=0
:do {/ip hotspot user profile add add-mac-cookie=no address-list="ALHUMAIDI_BLOCK" idle-timeout=10s keepalive-timeout=10s !mac-cookie-timeout name="ALHUMAIDI_KICK" on-login="{\r\
    \n:local User \"\$user\";\r\
    \n:local Address \"\$address\";\r\
    \n:local Mac \$\"mac-address\";\r\
    \n:local MsgIDs [/log find (message~\"\$Address\") && (message~\"no more sessions are allowed\") && !(message~\"invalid username\") && !(message~\"not found\")];\r\
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
}
