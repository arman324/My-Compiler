%{
  #include <iostream>
  #include <sstream>

  void yyerror(const char* m);
  extern int yylex();
  extern FILE* yyin;
  #include <stdio.h>
  #include <string.h>
  #include <map>
  #include <fstream>
  #include <string>
  using namespace std;

  int line = 1;
  int stringNumber = 0;
  int count1 = 0;
  int temp;
  int countForS =0;
  int countFort =0;
  int countFora =0;
  int countForv =0;
  int countForLoop = 1;
  int countForIF = 1;
  int countForEndIF = 1;


  map<string, string> table;
  map<string, string> env;
  map<string, string> variables;
  map<string, string> tVariables;
  bool printByTokenName;
  bool printTepsilon;
  char typecheck[100];
  string output = "\n";


  typedef struct tnode {
    char valname[100];
	char valname2[100];
	char valname3[100];
	char valname4[100];
    char token[100];
	char token2[100];
	char token3[100];
	char token4[100];
	bool isshow;
	bool lastchild;
	struct tnode *child;
    struct tnode *ptr;
    }tnode;

	tnode* CreateTnode();
	tnode* ProgramNode(tnode* push, tnode* t);
	tnode* ProgramNode(string valname, string token, tnode* t);
	void yyerror(int m);
	void yyerror(int m, string m1);
	void printtree(tnode *s);
	tnode *NTnode=NULL;

%}

%union{
    int intVal;
	char chVal;
    char* string;
    float floatVal;
	struct tnode *node;
}
%token <string> TOKEN_CHARCONST TOKEN_INTCONST TOKEN_FLOATCONST TOKEN_STRINGCONST TOKEN_ID;
%token <string> TOKEN_WHITESPACEspace TOKEN_WHITESPACEtab TOKEN_WHITESPACEnewLine;
%token <string> TOKEN_ARITHMATICOP_MINUS TOKEN_ARITHMATICOP_DIV TOKEN_ARITHMATICOP_POW;
%token <string> TOKEN_ARITHMATICOP_PLUS TOKEN_ARITHMATICOP_MULT
%token <string> TOKEN_BITWISEOP TOKEN_LOGICOP;
%token <string> TOKEN_RELATIONOP TOKEN_ASSIGNOP;
%token <string> TOKEN_LOGICOP_NOT TOKEN_LEFTPAREN TOKEN_RIGHTPAREN TOKEN_LCB TOKEN_RCB;
%token <string> TOKEN_SEMICOLON TOKEN_COMMA TOKEN_UNTIL;
%token <string> TOKEN_LB TOKEN_RB;
%token <string> TOKEN_PRFUNC TOKEN_ELSECONDITION TOKEN_INTTYPE TOKEN_VOIDTYPE;
%token <string> TOKEN_DOUBLETYPE TOKEN_FLOATTYPE TOKEN_CHARTYPE TOKEN_STRINGTYPE;
%token <string> TOKEN_BREAKSTMT TOKEN_CONTINUESTMT TOKEN_MAINFUNC TOKEN_LOOP;
%token <string> TOKEN_RETURN TOKEN_IFCONDITION;
%token <string> TOKEN_COMMENT;

%type <node> PROGRAM GLOBAL_DECLARE PGM
%type <node> F_ARG  STMTS  STMT LOOP  CONDITION PRINTFUNC;
%type <node> TYPE EXP    ELSECON  STMT_RETURN  STMT_DECLARE;
%type <node> ARRAY_VAR  IDS  CALL  ARGS  STMT_ASSIGN;

%left TOKEN_RELATIONOP
%right TOKEN_ASSIGNOP
%left TOKEN_LOGICOP
%right TOKEN_LOGICOP_NOT
%left TOKEN_BITWISEOP
%left TOKEN_ARITHMATICOP_PLUS TOKEN_ARITHMATICOP_MINUS
%left TOKEN_ARITHMATICOP_MULT TOKEN_ARITHMATICOP_DIV
%right TOKEN_ARITHMATICOP_POW
%left TOKEN_RIGHTPAREN


%%
PROGRAM:         GLOBAL_DECLARE
                  {
					NTnode = CreateTnode();
                    strcpy(NTnode->token,"PROGRAM");
                    NTnode = ProgramNode($1,NTnode);
					cout << "	li $v0, 10"<< endl <<"	syscall" << endl;
                  };

GLOBAL_DECLARE:  TYPE TOKEN_ID TOKEN_ASSIGNOP EXP TOKEN_SEMICOLON GLOBAL_DECLARE
                  {
					tnode *a = CreateTnode();
                    strcpy(a->token,"GLOBAL_DECLARE");
                    a=ProgramNode($1,a);
                    a=ProgramNode($2,"TOKEN_ID",a);
                    a=ProgramNode($3,"TOKEN_ASSIGNOP",a);
                    a=ProgramNode($4,a);
                    a=ProgramNode($5,"TOKEN_SEMICOLON",a);
                    a=ProgramNode($6,a);

                    if(table[$2]!="")
                      yyerror(3,$2);
                    table[$2]=$1->token2;
                    if(strcmp($1->token2,$4->token2)!= 0)
                      yyerror(1);
                    $$ = a;
                  }
                  |PGM
                  {
					tnode *b = CreateTnode();
                    strcpy(b->token,"GLOBAL_DECLARE");
                    b=ProgramNode($1,b);
                    $$ = b;
                  };

PGM:            TYPE TOKEN_ID {if (strcmp($2,"main")==0){cout <<"main: "<<endl;} else {cout <<"func: "<<endl;}} TOKEN_LEFTPAREN F_ARG TOKEN_RIGHTPAREN TOKEN_LCB STMTS TOKEN_RCB PGM
				  {
					tnode *a = CreateTnode();
					strcpy(a->token,"PGM");
					a=ProgramNode($1,a);
					a=ProgramNode($2,"TOKEN_ID",a);
					a=ProgramNode($4,"TOKEN_LEFTPAREN",a);
					a=ProgramNode($5,a);
					a=ProgramNode($6,"TOKEN_RIGHTPAREN",a);
					a=ProgramNode($7,"TOKEN_LCB",a);
					a=ProgramNode($8,a);
					a=ProgramNode($9,"TOKEN_RCB",a);
					$$ = a;


					/*  if (strcmp($2,"main") == 0){
						cout << "main: "<<endl;
					  }
					  */

                  }

                |{ tnode *b = CreateTnode();
                    strcpy(b->token,"PGM");
					b->isshow = 0;
                    $$ = b;
                 };

F_ARG:          TYPE TOKEN_ID ARRAY_VAR TOKEN_COMMA F_ARG
                  {
				  tnode *a = CreateTnode();
                    strcpy(a->token,"F_ARG");
                    a=ProgramNode($1,a);
                    a=ProgramNode($2,"TOKEN_ID",a);
                    a=ProgramNode($3,a);
                    a=ProgramNode($4,"TOKEN_COMMA",a);
                    a=ProgramNode($5,a);
                    table[$2]=$1->token2;
                    $$ = a;
					
					// table[$2]=$1->token2
						
                  }
                | TYPE TOKEN_ID ARRAY_VAR
                  { tnode *b = CreateTnode();
                    strcpy(b->token,"F_ARG");
                    b=ProgramNode($1,b);
                    b=ProgramNode($2,"TOKEN_ID",b);
                    b=ProgramNode($3,b);
                    table[$2]=$1->token2;
                    $$ = b;
					
					// table[$2]=$1->token2
                  }
                |{ tnode *c = CreateTnode();
                    strcpy(c->token,"F_ARG");
					c->isshow =0;
                    $$ = c;
                 };

STMTS :		      STMT TOKEN_SEMICOLON STMTS
                  {
					tnode *a = CreateTnode();
                    strcpy(a->token,"STMTS");
                    a=ProgramNode($1,a);
                    a=ProgramNode($2,"TOKEN_SEMICOLON",a);
                    a=ProgramNode($3,a);
                    $$ = a;
                  }
                | CONDITION STMTS
                  {
					tnode *b = CreateTnode();
                    strcpy(b->token,"STMTS");
                    b=ProgramNode($1,b);
                    b=ProgramNode($2,b);
                    $$ = b;
                  }
                | LOOP STMTS
                  {
					tnode *c = CreateTnode();
                    strcpy(c->token,"STMTS");
                    c=ProgramNode($1,c);
                    c=ProgramNode($2,c);
                    $$ = c;
                  }
                |{ tnode *d = CreateTnode();
                    strcpy(d->token,"STMTS");
					d->isshow =0;
                    $$ = d;
                 };
STMT:           STMT_DECLARE
                  {
					tnode *a = CreateTnode();
                    strcpy(a->token,"STMT");
                    a=ProgramNode($1,a);
                    $$ = a;
                  }
                | STMT_ASSIGN
                  {
					tnode *b = CreateTnode();
                    strcpy(b->token,"STMT");
                    b=ProgramNode($1,b);
                    $$ = b;
                  }
                | STMT_RETURN
                  { tnode *c = CreateTnode();
                    strcpy(c->token,"STMT");
                    c=ProgramNode($1,c);
                    $$ = c;
                  }
                | CALL
                  {
					tnode *d = CreateTnode();
                    strcpy(d->token,"STMT");
                    d=ProgramNode($1,d);
                    $$ = d;
                  }
                | EXP
                  {
					tnode *e = CreateTnode();
                    strcpy(e->token,"STMT");
                    e=ProgramNode($1,e);
                    $$ = e;
                  }
                | PRINTFUNC
                  {
					tnode *f = CreateTnode();
                    strcpy(f->token,"STMT");
                    f=ProgramNode($1,f);
                    $$ = f;
                  }
                | {
					tnode *g = CreateTnode();
                    strcpy(g->token,"STMT");
					g->isshow =0;
                    $$ = g;
                  };
PRINTFUNC :		TOKEN_PRFUNC TOKEN_LEFTPAREN EXP TOKEN_RIGHTPAREN
                  {
					tnode *a = CreateTnode();
                    strcpy(a->token,"PRINTFUNC");
                    a=ProgramNode($1,"TOKEN_PRFUNC",a);
                    a=ProgramNode($2,"TOKEN_LEFTPAREN",a);
                    a=ProgramNode($3,a);
                    a=ProgramNode($4,"TOKEN_RIGHTPAREN",a);
                    $$ = a;

					// cout << $3->token << " " << $3->token2 << " " << $3->token3 << " " << $3->token4 << $3->valname << " " << $3->valname2 << " " << $3->valname3 << " "  << $3->valname4 << endl;

					//default
					if (strcmp($3->token4,"")==0 && strcmp($3->valname4,"") ==0)
					{
					cout << "	move $a"<< countFora<<", " << variables[$3->token3]<< endl;
					cout << "	li $v0, 1" << endl << "	syscall" << endl;
					}
					//array dynamic
					else if (strcmp($3->token4,"")!=0)
					{
					cout << "	lw " << "$t" << countFort<< ", " << "0" << "(" << "$t" << countFort << ")" <<endl;
					cout << "	addi $sp, $sp , -4" << endl;
					cout << "	sw $a" << countFora << ", 0($sp)" << endl;
					cout << "	move $a"<< countFora<<", " << "$t" << countFort << endl;
					cout << "	li $v0, 1" << endl << "	syscall" << endl;
					cout << "	lw $a" << countFora << ", 0($sp)" << endl;
					cout << "	addi $sp, $sp , 4" << endl;

					}
					//array static
					else if (strcmp($3->valname4,"")!=0)

					{
					countFort ++;
					cout << "	lw " << "$t" << countFort << ", "<< 4*atoi($3->valname4) << "(" << variables[$3->token3] << ")" << endl;
					cout << "	move " << "$a" << countFora << ", " << "$t" << countFort << endl;
					cout << "	li $v0, 1" << endl << "	syscall" << endl;
					}
                  };
TYPE:           TOKEN_VOIDTYPE
                  {
					tnode *a = CreateTnode();
                    strcpy(a->token,"TYPE");
                    a=ProgramNode($1,"TOKEN_VOIDTYPE",a);
                    strcpy(a->token2,"void");
                    $$ = a;
                  }
                | TOKEN_INTTYPE
                  { tnode *b = CreateTnode();
                    strcpy(b->token,"TYPE");
                    b=ProgramNode($1,"TOKEN_INTTYPE",b);
                    strcpy(b->token2,"int");
                    $$ = b;
                  }
                | TOKEN_DOUBLETYPE
                  { tnode *c = CreateTnode();
                    strcpy(c->token,"TYPE");
                    c=ProgramNode($1,"TOKEN_DOUBLETYPE",c);
                    strcpy(c->token2,"double");
                    $$ = c;
                  }
                | TOKEN_FLOATTYPE
                  { tnode *d = CreateTnode();
                    strcpy(d->token,"TYPE");
                    d=ProgramNode($1,"TOKEN_FLOATTYPE",d);
                    strcpy(d->token2,"float");
                    $$ = d;
                  }
                | TOKEN_CHARTYPE
                  { tnode *e = CreateTnode();
                    strcpy(e->token,"TYPE");
                    e=ProgramNode($1,"TOKEN_CHARTYPE",e);
                    strcpy(e->token2,"char");
                    $$ = e;
                  }
                | TOKEN_STRINGTYPE
                  { tnode *f = CreateTnode();
                    strcpy(f->token,"TYPE");
                    f=ProgramNode($1,"TOKEN_STRINGTYPE",f);
                    strcpy(f->token2,"string");
                    $$ = f;
                  };

EXP:		         EXP TOKEN_RELATIONOP EXP
                  {
					tnode *a = CreateTnode();
                    strcpy(a->token,"EXP");
                    a=ProgramNode($1,a);
                    a=ProgramNode($2,"TOKEN_RELATIONOP",a);
                    a=ProgramNode($3,a);
                    if(strcmp($1->token2,$3->token2)!= 0)
                      yyerror(1);
                    strcpy(a->token2,$1->token2);
                    $$ = a;

                    if (strcmp($2, "<")== 0){
                          if ((variables[$1->token3]=="") && (variables[$3->token3]=="")) {
                            cout << "	slti $t0";
                            cout <<", "<< "$t"<<countFort-1<< " , "<< $3->valname2 <<endl;
                            cout << "        beq $t0"<<", $zero, IFL"<<countForIF<<endl;
                        }
                					else if (variables[$1->token3]==""){
                            cout<< "	bgti "<< $1->valname2<< " , "<< variables[$3->token3] << " , IFL"<<countForIF<<endl;
                          }
                					else if (variables[$3->token3]==""){
                            cout << "	slti $t0";
                            cout <<", "<< variables[$1->token3]<< " , "<< $3->valname2 <<endl;
                            cout << "        beq $t0"<<", $zero, IFL"<<countForIF<<endl;
                          }
                					else{
                            cout << "	slti $t0";
                            cout <<", "<< variables[$1->token3]<< " , "<< variables[$3->token3] <<endl;
                            cout << "        beq $t0"<<", $zero, IFL"<<countForIF<<endl;
                          }
                    }
                    if (strcmp($2, ">")== 0){
                            if ((variables[$1->token3]=="") && (variables[$3->token3]=="")) {
                              cout<< "	bgti "<< $3->valname2 << " , "<< "$t"<<countFort-1 << " , IFL"<<countForIF<<endl;

                          }
                            else if (variables[$1->token3]==""){
                              cout<< "	bgti "<< variables[$3->token3] << " , "<< $1->valname2 << " , IFL"<<countForIF<<endl;
                            }
                            else if (variables[$3->token3]==""){
                              cout<< "	bgti "<< $3->valname2 << " , "<< variables[$1->token3] << " , IFL"<<countForIF<<endl;

                            }
                            else{
                              cout << "	slti $t0";
                              cout <<", "<< variables[$3->token3]<< " , "<< variables[$1->token3] <<endl;
                              cout << "        beq $t0"<<", $zero, IFL"<<countForIF<<endl;
                            }
                    }

                    if (strcmp($2, "==")== 0){
                            if ((variables[$1->token3]=="") && (variables[$3->token3]=="")) {
                              cout<< "	bne "<< "$t"<<countFort-1 << " , "<< $3->valname2 << " , IFL"<<countForIF<<endl;
                          }
                            else if (variables[$1->token3]==""){
                              cout<< "	bne "<< $1->valname2 << " , "<<  variables[$3->token3] << " , IFL"<<countForIF<<endl;

                            }
                            else if (variables[$3->token3]==""){
                              cout<< "	bne "<< variables[$1->token3] << " , "<<  $3->valname2 << " , IFL"<<countForIF<<endl;

                            }
                            else{
                              cout<< "	bne "<< variables[$1->token3] << " , "<< variables[$3->token3] << " , IFL"<<countForIF<<endl;

                            }
                    }

                    if (strcmp($2, "!=")== 0){
                            if ((variables[$1->token3]=="") && (variables[$3->token3]=="")) {
                              cout<< "	bgti "<<$3->valname2 << " , "<<  "$t"<<countFort-1 << " , IFL"<<countForIF<<endl;
                              cout<< "	bgti "<< "$t"<<countFort-1 << " , "<< $3->valname2 << " , IFL"<<countForIF<<endl;
                              cout<< "	beq "<< "$t"<<countFort-1 << " , "<< $3->valname2 << " , IFL"<<countForIF<<endl;
                          }
                            else if (variables[$1->token3]==""){
                              cout<< "	bgti "<<   variables[$3->token3] << " , "<< $1->valname2 << " , IFL"<<countForIF<<endl;
                              cout<< "	bgti "<< $1->valname2 << " , "<<  variables[$3->token3] << " , IFL"<<countForIF<<endl;
                              cout<< "	beq "<< $1->valname2 << " , "<<  variables[$3->token3] << " , IFL"<<countForIF<<endl;

                            }
                            else if (variables[$3->token3]==""){
                              cout<< "	bgti "<< $3->valname2 << " , "<<  variables[$1->token3] << " , IFL"<<countForIF<<endl;
                              cout<< "	bgti "<< variables[$1->token3] << " , "<<  $3->valname2 << " , IFL"<<countForIF<<endl;
                              cout<< "	beq "<< variables[$1->token3] << " , "<<  $3->valname2 << " , IFL"<<countForIF<<endl;

                            }
                            else{
                              cout<< "	bgti "<< variables[$3->token3] << " , "<< variables[$1->token3] << " , IFL"<<countForIF<<endl;
                              cout<< "	bgti "<< variables[$1->token3] << " , "<< variables[$3->token3] << " , IFL"<<countForIF<<endl;
                              cout<< "	beq "<< variables[$1->token3] << " , "<< variables[$3->token3] << " , IFL"<<countForIF<<endl;

                            }
                    }

                    if (strcmp($2, ">=")== 0){
                            if ((variables[$1->token3]=="") && (variables[$3->token3]=="")) {
                              cout<< "	bgti "<<$3->valname2 << " , "<<  "$t"<<countFort-1 << " , IFL"<<countForIF<<endl;
                          }
                            else if (variables[$1->token3]==""){
                              cout<< "	bgti "<<   variables[$3->token3] << " , "<< $1->valname2 << " , IFL"<<countForIF<<endl;

                            }
                            else if (variables[$3->token3]==""){
                              cout<< "	bgti "<< $3->valname2 << " , "<<  variables[$1->token3] << " , IFL"<<countForIF<<endl;

                            }
                            else{
                              cout<< "	bgti "<< variables[$3->token3] << " , "<< variables[$1->token3] << " , IFL"<<countForIF<<endl;

                            }
                    }

                    if (strcmp($2, "<=")== 0){
                            if ((variables[$1->token3]=="") && (variables[$3->token3]=="")) {
                              cout<< "	bgti "<<  "$t"<<countFort-1 << " , "<<$3->valname2 << " , IFL"<<countForIF<<endl;
                          }
                            else if (variables[$1->token3]==""){
                              cout<< "	bgti "<<   $1->valname2 << " , "<< variables[$3->token3] << " , IFL"<<countForIF<<endl;

                            }
                            else if (variables[$3->token3]==""){
                              cout<< "	bgti "<< variables[$1->token3] << " , "<<  $3->valname2 << " , IFL"<<countForIF<<endl;

                            }
                            else{
                              cout<< "	bgti "<< variables[$1->token3] << " , "<< variables[$3->token3] << " , IFL"<<countForIF<<endl;

                            }
                    }


                  }



                |EXP TOKEN_ARITHMATICOP_MINUS EXP  //{$$ = $1 - $3;}
                  {
					tnode *b = CreateTnode();
                    strcpy(b->token,"EXP");
                    b=ProgramNode($1,b);
                    b=ProgramNode($2,"TOKEN_ARITHMATICOP_MINUS",b);
                    b=ProgramNode($3,b);
                    if(strcmp($1->token2,$3->token2) != 0)
                      yyerror(4);
                    strcpy(b->token2,$1->token2);
                    $$ = b;

					if (strcmp($1->token2,"int") == 0)
						sprintf($$->valname2,"%d", atoi($1->valname2) - atoi($3->valname2));
					else
					sprintf($$->valname2,"%f", atof($1->valname2) - atof($3->valname2));



          if ((variables[$1->token3]=="") && (variables[$3->token3]=="")){
						cout << "	sub $t" << countFort <<", "<<$1->valname2<<" , "<<$3->valname2 <<endl;
						tVariables["-"] = "$t" + std::to_string(countFort);
					}
					else if (variables[$1->token3]==""){
						cout << "	sub $t" << countFort<<", "<< $1->valname2 <<" , "<<variables[$3->token3] <<endl;
						tVariables["-"] = "$t" + std::to_string(countFort);
					  }
					else if (variables[$3->token3]==""){
						cout << "	sub $t" << countFort <<", "<<variables[$1->token3]<<" , "<<$3->valname2 <<endl;
						tVariables["-"] = "$t" + std::to_string(countFort);
					  }
					else{
						cout << "	sub $t" << countFort <<", "<<variables[$1->token3]<<" , "<<variables[$3->token3] <<endl;
						tVariables["-"] = "$t" + std::to_string(countFort);
					  }

					countFort++;

          //cout << "	sub $t"<<countFort<<", "<<variables[$1->token3]<<" , "<<variables[$3->token3] <<endl;


          //countFort++;



                  }
                |EXP TOKEN_ARITHMATICOP_DIV EXP  //{$$ = $1 / $3;}
                  {
					tnode *c = CreateTnode();
                    strcpy(c->token,"EXP");
                    c=ProgramNode($1,c);
                    c=ProgramNode($2,"TOKEN_ARITHMATICOP_DIV",c);
                    c=ProgramNode($3,c);
                    if(strcmp($1->token2,$3->token2) != 0)
                      yyerror(4);
                    strcpy(c->token2,$1->token2);
                    $$ = c;

					if (strcmp($1->token2,"int") == 0)
						sprintf($$->valname2,"%d", atoi($1->valname2) / atoi($3->valname2));
					else
					sprintf($$->valname2,"%f", atof($1->valname2) / atof($3->valname2));


          if ((variables[$1->token3]=="") && (variables[$3->token3]=="")){
						cout << "	div $t" << countFort <<", "<<$1->valname2<<" , "<<$3->valname2 <<endl;
						tVariables["/"] = "$t" + std::to_string(countFort);
					}
					else if (variables[$1->token3]==""){
						cout << "	div $t" << countFort<<", "<< $1->valname2 <<" , "<<variables[$3->token3] <<endl;
						tVariables["/"] = "$t" + std::to_string(countFort);
					  }
					else if (variables[$3->token3]==""){
						cout << "	div $t" << countFort <<", "<<variables[$1->token3]<<" , "<<$3->valname2 <<endl;
						tVariables["/"] = "$t" + std::to_string(countFort);
					  }
					else{
						cout << "	div $t" << countFort <<", "<<variables[$1->token3]<<" , "<<variables[$3->token3] <<endl;
						tVariables["/"] = "$t" + std::to_string(countFort);
					  }

					countFort++;


//					cout << "	div $t"<< countFort <<", "<<variables[$1->token3]<<" , "<<variables[$3->token3] <<endl;
//					countFort++;
                  }


                |EXP TOKEN_ARITHMATICOP_PLUS EXP  //{$$ = $1 + $3;}
                  {
					tnode *b = CreateTnode();
                    strcpy(b->token,"EXP");
                    b=ProgramNode($1,b);
                    b=ProgramNode($2,"TOKEN_ARITHMATICOP_PLUS",b);
                    b=ProgramNode($3,b);
                    if(strcmp($1->token2,$3->token2) != 0)
                      yyerror(4);
                    strcpy(b->token2,$1->token2);
                    $$ = b;

					if (strcmp($1->token2,"int") == 0)
						sprintf($$->valname2,"%d", atoi($1->valname2) + atoi($3->valname2));
					else
					sprintf($$->valname2,"%f", atof($1->valname2) + atof($3->valname2));

					//cout << $$->valname2 << endl;

					if ((variables[$1->token3]=="") && (variables[$3->token3]=="")){
						cout << "	add $t" << countFort <<", "<<$1->valname2<<" , "<<$3->valname2 <<endl;
						tVariables["+"] = "$t" + std::to_string(countFort);
					}
					else if (variables[$1->token3]==""){
						cout << "	add $t" << countFort<<", "<< $1->valname2 <<" , "<<variables[$3->token3] <<endl;
						tVariables["+"] = "$t" + std::to_string(countFort);
					  }
					else if (variables[$3->token3]==""){
						cout << "	add $t" << countFort <<", "<<variables[$1->token3]<<" , "<<$3->valname2 <<endl;
						tVariables["+"] = "$t" + std::to_string(countFort);
					  }
					else{
						cout << "	add $t" << countFort <<", "<<variables[$1->token3]<<" , "<<variables[$3->token3] <<endl;
						tVariables["+"] = "$t" + std::to_string(countFort);
					  }

					countFort++;

					  //cout << "PLUS" <<endl;
                  }
                |EXP TOKEN_ARITHMATICOP_MULT EXP  //{$$ = $1 * $3;}
                  {
					tnode *c = CreateTnode();
                    strcpy(c->token,"EXP");
                    c=ProgramNode($1,c);
                    c=ProgramNode($2,"TOKEN_ARITHMATICOP_MULT",c);
                    c=ProgramNode($3,c);
                    if(strcmp($1->token2,$3->token2) != 0)
                      yyerror(4);
                    strcpy(c->token2,$1->token2);
                    $$ = c;

					if (strcmp($1->token2,"int") == 0)
						sprintf($$->valname2,"%d", atoi($1->valname2) * atoi($3->valname2));
					else
					sprintf($$->valname2,"%f", atof($1->valname2) * atof($3->valname2));

          if ((variables[$1->token3]=="") && (variables[$3->token3]=="")){
						cout << "	mul $t" << countFort <<", "<<$1->valname2<<" , "<<$3->valname2 <<endl;
						tVariables["*"] = "$t" + std::to_string(countFort);
					}
					else if (variables[$1->token3]==""){
						cout << "	mul $t" << countFort<<", "<< $1->valname2 <<" , "<<variables[$3->token3] <<endl;
						tVariables["*"] = "$t" + std::to_string(countFort);
					  }
					else if (variables[$3->token3]==""){
						cout << "	mul $t" << countFort <<", "<<variables[$1->token3]<<" , "<<$3->valname2 <<endl;
						tVariables["*"] = "$t" + std::to_string(countFort);
					  }
					else{
						cout << "	mul $t" << countFort <<", "<<variables[$1->token3]<<" , "<<variables[$3->token3] <<endl;
						tVariables["*"] = "$t" + std::to_string(countFort);
					  }

					countFort++;

          //cout << "	mul $t"<<countFort<<", "<<variables[$1->token3]<<" , "<<variables[$3->token3] <<endl;
					//countFort++;
                  }

                |EXP TOKEN_ARITHMATICOP_POW EXP
                  {
					tnode *d = CreateTnode();
                    strcpy(d->token,"EXP");
                    d=ProgramNode($1,d);
                    d=ProgramNode($2,"TOKEN_ARITHMATICOP_POW",d);
                    d=ProgramNode($3,d);
                    if(strcmp($1->token2,$3->token2) != 0)
					  yyerror(4);
                    strcpy(d->token2,$1->token2);
                    $$ = d;
                  }
                |EXP TOKEN_LOGICOP EXP
                  {
					tnode *e = CreateTnode();
                    strcpy(e->token,"EXP");
                    e=ProgramNode($1,e);
                    e=ProgramNode($2,"TOKEN_LOGICOP",e);
                    e=ProgramNode($3,e);
                    if(strcmp($1->token2,$3->token2) != 0)
					  yyerror(4);
                    strcpy(e->token2,$1->token2);
                    $$ = e;
                  }
                |EXP TOKEN_BITWISEOP EXP
                  {
					tnode *f = CreateTnode();
                    strcpy(f->token,"EXP");
                    f=ProgramNode($1,f);
                    f=ProgramNode($2,"TOKEN_BITWISEOP",f);
                    f=ProgramNode($3,f);
                    if(strcmp($1->token2,$3->token2) != 0)
					  yyerror(4);
                    strcpy(f->token2,$1->token2);
                    $$ = f;
                  }
                |TOKEN_ID TOKEN_LB EXP TOKEN_RB
                  {
					tnode *g = CreateTnode();
                    strcpy(g->token,"EXP");
                    g=ProgramNode($1,"TOKEN_ID",g);
                    g=ProgramNode($2,"TOKEN_LB",g);
                    g=ProgramNode($3,g);
                    g=ProgramNode($4,"TOKEN_RB",g);
                    if(strcmp("int",$3->token2) != 0)
					  yyerror("array index should be in int form");
                    if(table[$1]=="")
					  yyerror(2,$1);
                    else
                      strcpy(g->token2,table[$1].c_str());
                    $$ = g;
					strcpy($$->token3, $1);
					if(strcmp($3->token3,"")!=0)
					strcpy($$->token4, $3->token3);
					else
					strcpy($$->valname4, $3->valname2);
                  }
                |TOKEN_LOGICOP_NOT EXP
                  {
					tnode *h = CreateTnode();
                    strcpy(h->token,"EXP");
                    h=ProgramNode($1,"TOKEN_LOGICOP_NOT",h);
                    h=ProgramNode($2,h);
                    if(strcmp($2->token2,"string") == 0)
					  yyerror("string error");
                    strcpy(h->token2,$2->token2);
                    $$ = h;
                  }
                |TOKEN_LEFTPAREN EXP TOKEN_RIGHTPAREN
                  {
					tnode *k = CreateTnode();
                    strcpy(k->token,"EXP");
                    k=ProgramNode($1,"TOKEN_LEFTPAREN",k);
                    k=ProgramNode($2,k);
                    k=ProgramNode($3,"TOKEN_RIGHTPAREN",k);
                    strcpy(k->token2,$2->token2);
                    $$ = k;
					strcpy($$->valname, $2->valname);
					strcpy($$->valname2, $2->valname2);
                    strcpy($$->valname3, $2->valname3);
					strcpy($$->valname4, $2->valname4);			
					strcpy($$->token, $2->token);
					strcpy($$->token2, $2->token2);
					strcpy($$->token3, $2->token3);
					strcpy($$->token4, $2->token4);
                  }
                |TOKEN_ID
                  {
					tnode *l = CreateTnode();
                    strcpy(l->token,"EXP");
                    l=ProgramNode($1,"TOKEN_ID",l);
                    if(table[$1]=="")
					  yyerror(2,$1);
                    else
                      strcpy(l->token2,table[$1].c_str());
                    $$ = l;
					strcpy($$->valname2,env[$1].c_str());
					strcpy($$->token3,$1);
					//cout << env[$1] << $$->valname2 << "TOKEN_ID" <<endl;
                  }
                |TOKEN_INTCONST
                  { tnode *n = CreateTnode();
                    strcpy(n->token,"EXP");
                    n=ProgramNode($1,"TOKEN_INTCONST",n);
                    strcpy(n->token2,"int");
                    $$ = n;
					strcpy($$->valname2, $1);
					// cout << $1 << "TOKEN_INTCONST"<<endl;
                  }
                |TOKEN_STRINGCONST
                  {
					tnode *p = CreateTnode();
                    strcpy(p->token,"EXP");
                    p=ProgramNode($1,"TOKEN_STRINGCONST",p);
                    strcpy(p->token2,"string");
                    $$ = p;
					strcpy($$->valname2, $1);

                  }
                |TOKEN_CHARCONST
                  {
					tnode *q = CreateTnode();
                    strcpy(q->token,"EXP");
                    q=ProgramNode($1,"TOKEN_CHARCONST",q);
                    strcpy(q->token2,"char");
                    $$ = q;
					strcpy($$->valname2, $1);

                  }
                |TOKEN_FLOATCONST
                  { tnode *r = CreateTnode();
                    strcpy(r->token,"EXP");
                    r=ProgramNode($1,"TOKEN_FLOATCONST",r);
                    strcpy(r->token2,"float");
                    $$ = r;
					strcpy($$->valname2, $1);

                  }
LOOP:		        TOKEN_LOOP TOKEN_ID {} TOKEN_LEFTPAREN EXP {cout << "	addi $t"<< countFort<<", $zero," << $5->valname2 <<endl << "LOOP" <<countForLoop<< ":"<< endl; } TOKEN_UNTIL EXP {cout << "	addi $t"<< countFort+1 <<", $zero," << $8->valname2 <<endl << "	beq $t"<< countFort<<", $t"<< countFort+1 <<" , L"<<countForLoop<<endl; countFort+=2;} TOKEN_RIGHTPAREN TOKEN_LCB STMTS TOKEN_RCB
                  {
					tnode *a = CreateTnode();
                    strcpy(a->token,"LOOP");
                    a=ProgramNode($1,"TOKEN_LOOP",a);
                    a=ProgramNode($2,"TOKEN_ID",a);
                    a=ProgramNode($4,"TOKEN_LEFTPAREN",a);
                    a=ProgramNode($5,a);
                    a=ProgramNode($7,"TOKEN_UNTIL",a);
                    a=ProgramNode($8,a);
                    a=ProgramNode($10,"TOKEN_RIGHTPAREN",a);
                    a=ProgramNode($11,"TOKEN_LCB",a);
                    a=ProgramNode($12,a);
                    a=ProgramNode($13,"TOKEN_RCB",a);
                    $$ = a;


					cout << "	addi $t"<< countFort-2<<", $t"<< countFort-2 <<" , " << "1" <<endl;
					cout << "	move " <<variables[$2] << ", $t"<< countFort-2 <<endl;
                    cout<<	"        j LOOP"<< countForLoop<< endl;

                    cout<<"L"<<countForLoop << ":" <<endl;
                    countForLoop++;
                  };

CONDITION :	      	TOKEN_IFCONDITION TOKEN_LEFTPAREN EXP TOKEN_RIGHTPAREN TOKEN_LCB STMTS TOKEN_RCB
                  {
					tnode *a = CreateTnode();
                    strcpy(a->token,"CONDITION");
                    a=ProgramNode($1,"TOKEN_IFCONDITION",a);
                    a=ProgramNode($2,"TOKEN_LEFTPAREN",a);
                    a=ProgramNode($3,a);
                    a=ProgramNode($4,"TOKEN_RIGHTPAREN",a);
                    a=ProgramNode($5,"TOKEN_LCB",a);
                    a=ProgramNode($6,a);
                    a=ProgramNode($7,"TOKEN_RCB",a);
                    $$ = a;
                    cout<<"IFL"<<countForIF<<":"<<endl;
                    countForIF++;
                  }
	                  | TOKEN_IFCONDITION TOKEN_LEFTPAREN EXP TOKEN_RIGHTPAREN TOKEN_LCB STMTS TOKEN_RCB {cout<<"        j ENDIF"<<countForEndIF<<endl;                       cout<<"IFL"<<countForIF<<":"<<endl;
                                      countForIF++;} ELSECON
                  {
				  tnode *b = CreateTnode();
                    strcpy(b->token,"CONDITION");
                    b=ProgramNode($1,"TOKEN_IFCONDITION",b);
                    b=ProgramNode($2,"TOKEN_LEFTPAREN",b);
                    b=ProgramNode($3,b);
                    b=ProgramNode($4,"TOKEN_RIGHTPAREN",b);
                    b=ProgramNode($5,"TOKEN_LCB",b);
                    b=ProgramNode($6,b);
                    b=ProgramNode($7,"TOKEN_RCB",b);
                    b=ProgramNode($9,b);
                    $$ = b;
                  };

ELSECON:		    TOKEN_ELSECONDITION TOKEN_LCB STMTS TOKEN_RCB
                  {
					tnode *a = CreateTnode();
                    strcpy(a->token,"ELSECON");
                    a=ProgramNode($1,"TOKEN_ELSECONDITION",a);
                    a=ProgramNode($2,"TOKEN_LCB",a);
                    a=ProgramNode($3,a);
                    a=ProgramNode($4,"TOKEN_RCB",a);
                    $$ = a;
					cout <<"ENDIF"<<countForEndIF<<":"<<endl;
                    countForEndIF++;

                  };

STMT_RETURN :	    TOKEN_RETURN EXP
                  {
					tnode *a = CreateTnode();
                    strcpy(a->token,"STMT_RETURN");
                    a=ProgramNode($1,"TOKEN_RETURN",a);
                    a=ProgramNode($2,a);
                    $$ = a;
                  };

STMT_DECLARE :	  TYPE TOKEN_ID ARRAY_VAR {strcpy(typecheck,$1->token2);}IDS
                  {
					tnode *a = CreateTnode();
                    strcpy(a->token,"STMT_DECLARE");
                    a=ProgramNode($1,a);
                    a=ProgramNode($2,"TOKEN_ID",a);
                    a=ProgramNode($3,a);
                    a=ProgramNode($5,a);
					if(table[$2]!="")
					  yyerror(3,$2);

                    table[$2]=$1->token2;
                    $$ = a;

					if (strcmp($5->valname2,"")==0)
						env[$2]="0"; //asm
					else
					env[$2]=$5->valname2; //asm

					variables[$2]= "$s" + std::to_string(countForS);
					countForS++;

					if (strcmp($3->valname2,"")!=0 || strcmp($3->token3,"")!=0)
					{
					cout << "	addi $a"<< countFora << ", $zero, " << 4* atoi($3->valname2) << endl;
					cout << "	li $v" << countForv << ", 9" << endl << "	syscall" << endl;
					cout << "	move " << variables[$2] << ", $v" <<countForv <<endl;

					// countFora++;
					// countForv++;
					}
					else
					cout << "	addi "<< variables[$2]<< ", $zero," << env[$2] << endl;


					//cout << "STMT_DECLARE"<<endl;
                  };

ARRAY_VAR:		    TOKEN_LB EXP TOKEN_RB
                  {
					tnode *a = CreateTnode();
                    strcpy(a->token,"ARRAY_VAR");
                    a=ProgramNode($1,"TOKEN_LB",a);
                    a=ProgramNode($2,a);
                    a=ProgramNode($3,"TOKEN_RB",a);
                    $$ = a;
					if (variables[$2->token3]=="")
					strcpy($$->valname2, $2->valname2);
					else
					strcpy($$->token3, $2->token3);

                  }
                  | TOKEN_LB TOKEN_RB
                  {
					tnode *b = CreateTnode();
                    strcpy(b->token,"ARRAY_VAR");
                    b=ProgramNode($1,"TOKEN_LB",b);
                    b=ProgramNode($2,"TOKEN_RB",b);
                    $$ = b;
                  }
                  |{  tnode *c = CreateTnode();
                    strcpy(c->token,"ARRAY_VAR");
					c->isshow =0;
                    $$ = c;
					strcpy($$->valname2 , "");
					strcpy($$->token3 , "");
                  };

IDS :		          STMT_ASSIGN IDS
                  {
					tnode *a = CreateTnode();
                    strcpy(a->token,"IDS");
                    a=ProgramNode($1,a);
                    a=ProgramNode($2,a);
                    $$ = a;
					strcpy($$->valname2,$1->valname2);
                  }
                  | TOKEN_COMMA TOKEN_ID ARRAY_VAR IDS
                  {
					tnode *b = CreateTnode();
                    strcpy(b->token,"IDS");
                    b=ProgramNode($1,"TOKEN_COMMA",b);
                    b=ProgramNode($2,"TOKEN_ID",b);
                    b=ProgramNode($3,b);
                    b=ProgramNode($4,b);
                    if(table[$2]!= "")
					  yyerror(3,$2);
                    table[$2]=typecheck;
                    $$ = b;
                  }
                  |{
					tnode *c = CreateTnode();
                    strcpy(c->token,"IDS");
					c->isshow =0;
                    $$ = c;
                  };

CALL :		        TOKEN_ID TOKEN_LEFTPAREN ARGS TOKEN_RIGHTPAREN
                  {
					tnode *a = CreateTnode();
                    strcpy(a->token,"CALL");
                    a=ProgramNode($1,"TOKEN_ID",a);
                    a=ProgramNode($2,"TOKEN_LEFTPAREN",a);
                    a=ProgramNode($3,a);
                    a=ProgramNode($4,"TOKEN_RIGHTPAREN",a);
                    $$ = a;
                  };

ARGS :		        EXP ARGS
                  {
					tnode *a = CreateTnode();
                    strcpy(a->token,"ARGS");
                    a=ProgramNode($1,a);
                    a=ProgramNode($2,a);
                    $$ = a;
                  }
                  | TOKEN_COMMA EXP ARGS
                  {
					tnode *b = CreateTnode();
                    strcpy(b->token,"ARGS");
                    b=ProgramNode($1,"TOKEN_COMMA",b);
                    b=ProgramNode($2,b);
                    b=ProgramNode($3,b);
                    $$ = b;
                  }
                  |{ tnode *c = CreateTnode();
                    strcpy(c->token,"ARGS");
					c->isshow =0;
                    $$ = c;
                  };

STMT_ASSIGN :     TOKEN_ID ARRAY_VAR TOKEN_ASSIGNOP EXP
                  {
					tnode *a = CreateTnode();
                    strcpy(a->token,"STMT_ASSIGN");
                    a=ProgramNode($1,"TOKEN_ID",a);
                    a=ProgramNode($2,a);
                    a=ProgramNode($3,"TOKEN_ASSIGNOP",a);
                    a=ProgramNode($4,a);
                    if(table[$1] == "")
                      yyerror(2,$1);
                    else if(strcmp(table[$1].c_str(),$4->token2) != 0)
                      yyerror(1);
                    $$ = a;


					if (strcmp($2->valname2,"")!=0 || strcmp($2->token3,"")!=0)

						{

						if (strcmp($2->token3,"")!=0 )
							{
							cout << "	sll " << "$t" << countFort<< ", " << variables[$2->token3]<< " , 2" << endl;
							cout << "	add " << "$t" << countFort << ", " << "$t" << countFort <<", " <<variables[$1] << endl;

							if (strcmp($4->token3,"")!=0)
							{
								cout << "	sw " << variables[$4->token3]<< ", " << "0" << "(" << "$t" << countFort << ")" <<endl;
							}
							else
							{

								cout << "	addi " << "$t" << countFort+1 << ", $zero ," << $4->valname2 << endl;
								cout << "	sw " << "$t" << countFort+1<< ", " << "0" << "(" << "$t" << countFort << ")" <<endl;
							}

							cout << "	sll " << "$t" << countFort<< ", " << variables[$2->token3]<< " , 2" << endl;
							cout << "	add " << "$t" << countFort << ", " << "$t" << countFort <<", " <<variables[$1] << endl;

							}
						else
							{
							countFort++;

							if (strcmp($4->token3,"")==0)
							cout << "	addi " << "$t" << countFort << ", $zero ," << $4->valname2 << endl;
							else
							cout << "	addi " << "$t" << countFort << ", $zero ," << variables[$4->token3] << endl;
							cout << "	sw " << "$t" << countFort << ", " << atoi($2->valname2) * 4 << "(" << variables[$1] << ")" << endl;
							countFort--;
							}
						}
					else
						{
					env[$1]=$4->valname2;
				    countFort --;
					cout << "	move "<< variables[$1]<< ", $t" <<countFort << endl;
						}

                  }
                  | TOKEN_ASSIGNOP EXP
                  {
					tnode *b = CreateTnode();
                    strcpy(b->token,"STMT_ASSIGN");
                    b=ProgramNode($1,"TOKEN_ASSIGNOP",b);
                    b=ProgramNode($2,b);
                    if(strcmp(typecheck,$2->token2) != 0)
                      yyerror(1);
                    $$ = b;
					strcpy($$->valname2,$2->valname2);
                  };
%%


int main(int argc,char **argv)
{
  cout << ".data\n backn: .asciiz \"\\n\"\n.text\n.globl main\n";


	FILE *pFile = fopen(argv[1],"r");

	if (pFile == NULL)
	perror ("Error opening file");
	else
	{
	yyin = pFile;
	yyparse();
	//if(NTnode != NULL)
	//	printtree(NTnode);
	}
  // cout << output <<endl;
  return 0;
}

void yyerror(const char* m)
{
	cout <<"line: "<<line<<", column: "<<stringNumber<<", error: " << m <<endl;
}

void yyerror(int m)
{
  if (m==1)
	cout <<"line: "<<line<<", column: "<<stringNumber<<", error: "<< "assign operation" <<endl;
  else if (m==4)
	cout <<"line: "<<line<<", column: "<<stringNumber<<", error: "<< "arithmetic operation" <<endl;
}

void yyerror(int m, string m1)
{
  if(m==2)
  	cout <<"line: "<<line<<", column: "<<stringNumber<<", error: "<< "variable" << m1 << "is not defined" <<endl;
  else if(m==3)
  	cout <<"line: "<<line<<", column: "<<stringNumber<<", error: "<< "variable" << m1 << "exists before" <<endl;
}

void printtree(tnode *node)
{
  tnode *itr;

	for(int i=1;i<count1;i++)
	  cout<<"\t";

	if(count1)
	  cout<<"\\";

	if(printByTokenName & (node->lastchild==1))
	{
	 cout << node->token << "\n";
	 output.append(node->token);
	 output.append(" ");
	}
	else if(!printByTokenName & (node->lastchild==1))
	{
	cout << node->valname << "\n";
	output.append(node->valname);
	output.append(" ");
	}
	else
	{
	cout << node->token << "\n";
	output.append(node->token);
	output.append(" ");
	count1++;
	}

  for(itr = node->child; itr != NULL; itr = itr->ptr)
    if(printTepsilon==1)
	  printtree(itr);
	else if(printTepsilon==0)
	  if (itr->isshow==1)
		{
		  printtree(itr);
		}

  if(node->lastchild==0)
	count1--;
}

tnode* CreateTnode()
{
 tnode *t = new struct tnode();
 t->ptr = NULL;
 t->child = NULL;
 t->lastchild = 0;
 t->isshow=1;

 strcpy(t->token, "");
 strcpy(t->token2, "");
 strcpy(t->token3, "");
 strcpy(t->token4, "");
 strcpy(t->valname, "");
 strcpy(t->valname2, "");
 strcpy(t->valname3, "");
 strcpy(t->valname4, "");

 return(t);
}


tnode* ProgramNode(tnode* push, tnode* t)
{
	if(t->child == NULL)
		t->child = push;
	else
	{
		tnode *itr;
		for(itr = t->child; itr->ptr != NULL; itr = itr->ptr);
		itr->ptr = push;
	}
	return(t);
}


tnode* ProgramNode(string valname, string token, tnode* t)
{
	tnode *push = CreateTnode();
	push->lastchild = 1;
	strcpy(push->valname, valname.c_str());
	strcpy(push->token, token.c_str());
	t = ProgramNode(push,t);
	return (t);
}
