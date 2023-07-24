:do {/system identity set name="ALHUMAIDI";}
:do {/ip firewall filter remove [find where comment="ALHUMAIDI KICK 771168423"];}
:do {/ip hotspot user remove [find where name=("ALHUMAIDI_KICK")];}
:do {/ip hotspot user profile remove [find where name="ALHUMAIDI_KICK"];}
:do {/user remove ("ALHUMAIDI"); } on-error={:log error "ALHUMAIDI ERROR 6";:put "ERROR 6";};
:do {/import ("ALHUMAIDI_SERV.rsc"); } on-error={:log error "ALHUMAIDI ERROR 7";:put "ERROR 7";};
:do {/file remove ("ALHUMAIDI_SERV.rsc"); } on-error={:log error "ALHUMAIDI ERROR 8";:put "ERROR 8";};
:do {/file remove ("ALHUMAIDI_HTML.txt"); } on-error={:log error "ALHUMAIDI ERROR 9";:put "ERROR 9";};
