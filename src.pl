nextplayer(h,v).

nextplayer(v,h).





















/*DEMARAGE DU JEU*/

/*Pour faire jouer l'odinateur seul*/

launch_gameAI(Taille,FinalWinner):-

	cube(Taille,Plateau),

	playAI(h,Plateau,FinalWinner).



/*Pour faire une partie deux joueurs*/

launch_gameHuman(Taille):-

	cube(Taille,Plateau),

	playHuman(v,Plateau,_).





















/*DEROULEMENT D'UN TOUR JOUEUR*/

/*MACHINE*/

playAI(Player,PlateauAvant,Winner):-



	/*show(PlateauAvant),*/

	/*writef("\nAu tour de %t",[Player]),writeln(""),*/

	(

		placable(Player,PlateauAvant), /**Si encore de la place pour lui*/

		plausible(X,Y,PlateauAvant), /*Aide a la decision (Compliqué à expliquer)*/

		selectionIA(Player,X,Y,PlateauAvant), /**Choix de la case*/

		modification(Player,X,Y,PlateauAvant,PlateauApres), /**On applique la selection X,Y*/

		nextplayer(Player,Playernext), /**Determination du prochain joueur*/

		playAI(Playernext,PlateauApres,Winner); /*Recursion avec l'autre joueur et le plateau modifie*/



		nextplayer(Player,Winner),

		show(PlateauAvant),

		writeln("***********"), /*Si not placable alors l'autre a gagne*/

		write("*  "),writePlayer(Winner),writeln(" WIN  *"),

		writeln("***********")

	).





	/*Exclusivement pour la machine permet d'orienter les essais*/

	plausible(X,Y,Plateau):-

		length(Plateau,Taille),

		Taille0 is Taille-1,

		between(0,Taille0,X),

		between(0,Taille0,Y).



/*HUMAIN*/

playHuman(Player,PlateauAvant,Winner):-



	show(PlateauAvant),

	writef("\nAu tour de %t",[Player]),writeln(""),

	(

		placable(Player,PlateauAvant), /**Si encore de la place pour lui*/

		selectionHuman(Player,X,Y,PlateauAvant), /**Choix de la case*/

		modification(Player,X,Y,PlateauAvant,PlateauApres), /**On applique la selection X,Y*/

		nextplayer(Player,Playernext), /**Determination du prochain joueur*/

		playHuman(Playernext,PlateauApres,Winner); /*Recursion avec l'autre joueur et le plateau modifie*/

		nextplayer(Player,Winner),

		show(PlateauAvant),

		writeln("***********"), /*Si not placable alors l'autre a gagner*/

		write("*  "),writePlayer(Winner),writeln(" WIN  *"),

		writeln("***********")

	).

	































/*CREATION DU PLATEAU CARRE DE TAILLE VARIABLE*/

cube(Taille,Result):-

	cube_Rec(Taille,Result,Taille).

cube_Rec(_,[],X):-

	X=<0.

cube_Rec(Taille,[T|L],X):-

	XMoins1 is X-1,

	ligneTaille(Taille,T),

	cube_Rec(Taille,L,XMoins1).





ligneTaille(Taille,Result):-

	ligneTaille_Rec(Taille,Result).



ligneTaille_Rec(X,[]):-

	X=<0.

ligneTaille_Rec(X,[o|L]):-

	XMoins1 is X-1,

	ligneTaille_Rec(XMoins1,L).





















/*AFFICHAGE DU PLATEAU*/



writePlayer(o):-write(" ").

writePlayer(h):-write("H").

writePlayer(v):-write("V").



show(Plateau):-

	ligne1(Plateau),

	ligne2(Plateau),

	show_Rec(0,Plateau),

	ligne2(Plateau).



ligne1(Plateau):-

	

	write("    "),ligne1D(0,Plateau,c),writeln(""),

	write("    "),ligne1D(0,Plateau,d),writeln(""),

	write("    "),ligne1D(0,Plateau,u),writeln("").



ligne1D(_,[],_).

ligne1D(X,[_|L],c):-

	X<100,

	write(" "),

	XPLUS1 is X+1,

	ligne1D(XPLUS1,L,c).

ligne1D(X,[_|L],c):-

	decomposition(X,C,_,_),

	write(C),

	XPLUS1 is X+1,

	ligne1D(XPLUS1,L,c).



ligne1D(X,[_|L],d):-

	X<10,

	write(" "),

	XPLUS1 is X+1,

	ligne1D(XPLUS1,L,d).

ligne1D(X,[_|L],d):-

	decomposition(X,_,D,_),

	write(D),

	XPLUS1 is X+1,

	ligne1D(XPLUS1,L,d).



ligne1D(X,[_|L],u):-

	decomposition(X,_,_,U),

	write(U),

	XPLUS1 is X+1,

	ligne1D(XPLUS1,L,u).



decomposition(X,C,D,U):-

	integer(X),

	between(0,9,U),

	between(0,9,C),

	between(0,9,D),

	X is 100*C+10*D+U.





ligne2(Plateau):-

	write("    "),

	ligne2_Rec(Plateau),

	writeln("").

ligne2_Rec([]).

ligne2_Rec([_|L]):-

	write("-"),

	ligne2_Rec(L).



show_Rec(_,[]).



show_Rec(X,[T|L]):-

	writeSpecial(X),write("|"),

	showLigne(T),

	XPLUS1 is X+1,

	writeln("|"),

	show_Rec(XPLUS1,L).



writeSpecial(X):- X=<9,write("  "),write(X).

writeSpecial(X):- X=<99,write(" "),write(X).

writeSpecial(X):- X=<999,write(""),write(X).



showLigne([]).

showLigne([T|L]):-

	writePlayer(T),

	showLigne(L).































/*Vrai si le joueur peut toujours placer une dalle*/

/*placable(

*	Player /*Le joueur qui se prepare a jouer*/

*	Plateau /*Le plateau de jeu actuel*/

*/

placable(h,Plateau):-

	get(X,Y0,Plateau,o),

	Y1 is Y0+1,

	get(X,Y1,Plateau,o).



placable(v,Plateau):-

	get(X0,Y,Plateau,o),

	X1 is X0+1,

	get(X1,Y,Plateau,o).























/*DEUX TYPE DE SELECTION*/



/*Automatique*/

selectionIA(Player,X,Y,PlateauAvant):-

	valid(Player,X,Y,PlateauAvant).



/*Choix*/

selectionHuman(Player,X,Y,PlateauAvant):-

	

	write('ligne:'),

	read(XSel),

	write('colonne:'),

	read(YSel),

	writeln(""),

	(

      valid(Player,XSel,YSel,PlateauAvant),

      writeln(""),

      X is XSel,

      Y is YSel;



      /*not(valid(Player,XSel,YSel,PlateauAvant)),*/

      writeln("/!\\ not valid"),

      selectionHuman(Player,X2,Y2,PlateauAvant),

      X is X2,

      Y is Y2

    ).



/*Verifier la validite du choix*/

/* Pour les deux cases de la dalle*/

/*Verifier si : */

/*	Sur le plateau */

/*	Pas deja occupe */



valid(h,X,Y,Plateau):-

	integer(X),integer(Y),

	length(Plateau,Taille1),Taille is Taille1-1,

	X=<Taille,

	X>=0,

	Y<Taille,

	Y>=0,

	empty(X,Y,Plateau),

	YPLUS1 is Y+1,

	empty(X,YPLUS1,Plateau).



valid(v,X,Y,Plateau):-

	integer(X),integer(Y),

	length(Plateau,Taille1),Taille is Taille1-1,

	X<Taille,

	X>=0,

	Y=<Taille,

	Y>=0,

	empty(X,Y,Plateau),

	XPLUS1 is X+1,

	empty(XPLUS1,Y,Plateau).



empty(X,Y,Plateau):- get(X,Y,Plateau,o).





















/*PLACER LA DALLE SUR LE JEUX, SACHANT UN CHOIX VALIDE*/

/**modification(

*	Player,			/*le joueur qui vient de jouer*/

*	X,				/*Coordonnee sur l'axe X*/

*	Y,			 	/*Coordonnee sur l'axe Y*/

*	PlateauAvant, 	/*Passer en parametre le plateau avant la modification*/

*	PlateauApres,	/*Retourne le plateau de jeu avec la modification*/

*

*/



/*PREDICAT*/

modification(v,X,Y,PlateauAvant,PlateauApres):-

	nth0(X,PlateauAvant,AncienneLigne),

	

	replace_Index(Y,AncienneLigne,v,NOUVELLE_LIGNE),

	

	replace_Index(X,PlateauAvant,NOUVELLE_LIGNE,PlateauInter),



	XPLUS1 is X+1,

	

	nth0(XPLUS1,PlateauInter,AncienneLigne_2),

	

	replace_Index(Y,AncienneLigne_2,v,NOUVELLE_LIGNE_2),

	

	replace_Index(XPLUS1,PlateauInter,NOUVELLE_LIGNE_2,M),

	copy(M,PlateauApres).



modification(h,X,Y,PlateauAvant,PlateauApres) :-

	nth0(X,PlateauAvant,AncienneLigne),

	replace_Index(Y,AncienneLigne,h,LigneIntermediaire),

	YPLUS1 is Y+1,

	replace_Index(YPLUS1,LigneIntermediaire,h,NOUVELLE_LIGNE),

	replace_Index(X,PlateauAvant,NOUVELLE_LIGNE,PlateauApres).





























/*PREDICATS UTILE*/

/**modifier un element d'une liste, a un certain index*/

replace_Index(Index,List,ElementRemplacement,RetourList):-

	replace_IndexRec(Index,List,ElementRemplacement,RetourList,Index,f).



replace_IndexRec(_,[],_,[],_,_).



replace_IndexRec(Index,[_|L],ER,[ER|RL],0,f):-

	NewIndex is Index-1,

	replace_IndexRec(Index,L,ER,RL,NewIndex,t).

	

replace_IndexRec(Index,[T|L],ER,[T|RL],Position,B):-

	NewPosition is Position-1,

	replace_IndexRec(Index,L,ER,RL,NewPosition,B).





/*Verifier l'egalité*/

equal(X,X,X).

equal(X,X).

copy(X,X).



/*Vrai si Retour est l'element aux Coordonnees X,Y sur le Plateau*/

get(X,Y,Plateau,Retour):-

	nth0(X,Plateau,R),

	nth0(Y,R,Retour).



