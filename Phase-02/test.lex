%{
  #include <iostream>
  using namespace std;
  #include <string.h>
  #include <stdio.h>
  #include "./myapp.hpp"
  extern int line;
  extern int stringNumber;
%}

%option noyywrap

%%
"//".*             {}

"/*".*"*/"   {}

\/\*([^*]|(\*[^*/]))*   {
                      printf("\033[1;31merror \033[0min line %d : unclosed comment section\n",line);
                       }

"*/"   {
             printf("\033[1;31merror \033[0min line %d : unopend comment section\n",line);
         }

\n              {++line;stringNumber=0;}
\t                    {}
" "                   {}


"print"               {
						yylval.string=strdup(yytext);
                        stringNumber += yyleng;
						return TOKEN_PRFUNC;
					  }

"else"                {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                        return TOKEN_ELSECONDITION;
					  }

"int"                 {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                        return TOKEN_INTTYPE;
					  }

"void"                {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
					   return TOKEN_VOIDTYPE;
					  }

"foreach"             {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                        return TOKEN_LOOP;
					   }

"return"              {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                        return TOKEN_RETURN;
					  }

"if"                  {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                        return TOKEN_IFCONDITION;
					  }

"+"                   {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                        return TOKEN_ARITHMATICOP_PLUS;
					  }

"-"                   {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                        return TOKEN_ARITHMATICOP_MINUS;
					  }

"/"                   {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                        return TOKEN_ARITHMATICOP_DIV;
					  }

"*"                   {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_ARITHMATICOP_MULT;
					  }

"&&"                  {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_LOGICOP;
					  }

"&"                   {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_BITWISEOP;
					  }

"|"                   {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_BITWISEOP;
					  }

"||"                  {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_LOGICOP;
					  }

"<="                  {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                        return TOKEN_RELATIONOP;
					  }

"<"                   {
					   yylval.string=strdup(yytext);
                        stringNumber += yyleng;
                         return TOKEN_RELATIONOP;
					  }

">"                   {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                        return TOKEN_RELATIONOP;
					  }

"="                   {
					    yylval.string=strdup(yytext);
                        stringNumber += yyleng;
                         return TOKEN_ASSIGNOP;
					  }

">="                  {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                        return TOKEN_RELATIONOP;
					  }

"=="                  {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
					   return TOKEN_RELATIONOP;
					  }

"!="                  {
					   yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                        return TOKEN_RELATIONOP;
					  }

"^"                   {
						yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_ARITHMATICOP_POW;
					  }

"!"                   {
						yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_LOGICOP_NOT;
					  }

"("                   {
						yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_LEFTPAREN;
					  }

")"                   {
						yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                        return TOKEN_RIGHTPAREN;
					   }

"{"                   {
						yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_LCB;
					  }

"}"                   {
						yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                        return TOKEN_RCB;
					   }

";"                   {
						yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_SEMICOLON;
					  }

","                   {
						yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_COMMA;}

".."                  {
						yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_UNTIL;
					  }

"["                   {
						yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_LB;
					  }

"]"                   {
						yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                        return TOKEN_RB;
					   }

"double"              {
						yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_DOUBLETYPE;
					  }

"float"               {
						yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_FLOATTYPE;
					  }

"char"                {
						yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_CHARTYPE;
					  }

"string"              {
						yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_STRINGTYPE;
					  }

"break"               {
						yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_BREAKSTMT;
					  }

"continue"            {
						yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_CONTINUESTMT;
					  }

"main"                {
						yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                       return TOKEN_ID;}

-?[0-9]*              {long mynumber = atol(yytext);
                       if(mynumber > 2147483648 || mynumber < -2147483649 || yyleng > 10)
                        {
                          printf("error in line %d : size of variable is out of range\n",line);
                          exit(0);
                        }
                        yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                        return TOKEN_INTCONST;
                      }


\'[ a-zA-Z0-9\"`~!@#$%^&\*()_\-=\+\]\[\{\},\.?]\' { yylval.string=strdup(yytext);
                          stringNumber += yyleng;
                          return TOKEN_CHARCONST;}


\"[ a-zA-Z0-9\'`~!@#$%^&\*()_\-=\+\]\[\{\},\.?]*(\\[ntvrfb\\"'a0])*\" {yylval.string=strdup(yytext);
                         stringNumber += yyleng;
                         return TOKEN_STRINGCONST;}

[a-zA-Z]+[0-9a-zA-Z|_]* {if(yyleng>31) {
                          printf("error in line %d : wrong id definition\n",line);
                          exit(0);
                        }
                        yylval.string=strdup(yytext);
                        stringNumber += yyleng;
                        return TOKEN_ID;
                      }

[0-9]+[0-9a-zA-Z|_]* {printf("error in line %d : wrong id definition\n",line);
                              exit(0);}


[-+]?[0-9]+"."[0-9]+ {
                      yylval.string=strdup(yytext);
                       stringNumber += yyleng;
                      return TOKEN_FLOATCONST;}
%%
