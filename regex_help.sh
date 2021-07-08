#!/bin/bash
echo -n "AND: "
echo -e $CYAN" (?=.*WORD1)(?=.*WORD2)"$ATTR_RESET
echo -e $CYAN" GREP version : \"WORD1.*WORD2\""$ATTR_RESET
echo -n "OR: "
echo -e $CYAN"WORD1|WORD2"$ATTR_RESET
echo -n "N'importe quel caractere dans le groupe: "
echo -e $CYAN"[character_group]"$ATTR_RESET
echo -n "Aucun des caracteres du groupe: "
echo -e $CYAN"[~character_group]"$ATTR_RESET

