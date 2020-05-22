%{
  #include <stdio.h>
  char line[1000];
  char error[1000];
  char stringNumber[5];
  long long int temp;
  int countLineNumber = 1;
%}

%option noyywrap

%%
\/\/.*             {
                    strcpy(line, "TOKEN_COMMENT ");
                    strcat(line,yytext);
                    strcat(line,"\n");
                    fprintf(yyout,"%s",line);
                    }

\/\*([^*]|(\*[^*/]))*    {
                      printf("\033[1;31merror \033[0min line %d : unclosed comment section\n",countLineNumber);
                      strcpy(error,"error in line ");
                      sprintf(stringNumber, "%d", countLineNumber);
                      strcat(error,stringNumber);
                      strcat(error," : unclosed comment section\n");
                      fprintf(yyout,"%s",error);
                    }

.*\*\/   {
                      printf("\033[1;31merror \033[0min line %d : unopend comment section\n",countLineNumber);
                      strcpy(error,"error in line ");
                      sprintf(stringNumber, "%d", countLineNumber);
                      strcat(error,stringNumber);
                      strcat(error," : unopend comment section\n");
                      fprintf(yyout,"%s",error);
                    }

\/\*([^*]|(\*[^*/]))*\*\/   {
                    strcpy(line, "TOKEN_COMMENT ");
                    strcat(line,yytext);
                    strcat(line,"\n");
                    fprintf(yyout,"%s",line);
                    }

" "                {
                    strcpy(line, "TOKEN_WHITESPACE [space]\n");
                    fprintf(yyout,"%s",line);
                    }

"int"          {
                    strcpy(line,"TOKEN_INTTYPE int\n");
                    fprintf(yyout,"%s",line);
                    }

"void"          {
                    strcpy(line,"TOKEN_VOIDTYPE void\n");
                    fprintf(yyout,"%s",line);
                    }

"double"          {
                    strcpy(line,"TOKEN_DOUBLETYPE double\n");
                    fprintf(yyout,"%s",line);
                    }
"float"          {
                    strcpy(line,"TOKEN_FLOATTYPE float\n");
                    fprintf(yyout,"%s",line);
                    }

"char"          {
                    strcpy(line,"TOKEN_CHARTYPE char\n");
                    fprintf(yyout,"%s",line);
                    }

"string"          {
                    strcpy(line,"TOKEN_STRINGTYPE string\n");
                    fprintf(yyout,"%s",line);
                    }
"break"          {
                    strcpy(line,"TOKEN_BREAKSTMT break\n");
                    fprintf(yyout,"%s",line);
                    }

"continue"          {
                    strcpy(line,"TOKEN_CONTINUESTMT continue\n");
                    fprintf(yyout,"%s",line);
                    }


"main"          {
                    strcpy(line,"TOKEN_MAINFUNC main\n");
                    fprintf(yyout,"%s",line);
                    }

"foreach"          {
                    strcpy(line,"TOKEN_LOOP foreach\n");
                    fprintf(yyout,"%s",line);
                    }

"return"          {
                    strcpy(line,"TOKEN_RETURN return\n");
                    fprintf(yyout,"%s",line);
                    }

"if"          {
                    strcpy(line,"TOKEN_IFCONDITION if\n");
                    fprintf(yyout,"%s",line);
                    }

[-]*[0-9]+                 {
                      sscanf(yytext, "%lld", &temp);
                      if (temp > 2147483647){
                        printf("\033[1;31merror \033[0min line %d : integer constant is out of range\n",countLineNumber);
                        strcpy(error,"error in line ");
                        sprintf(stringNumber, "%d", countLineNumber);
                        strcat(error,stringNumber);
                        strcat(error," : integer constant is out of range\n");
                        fprintf(yyout,"%s",error);
                      }
                    else if (temp < -2147483648){
                        printf("\033[1;31merror \033[0min line %d : integer constant is out of range\n",countLineNumber);
                        strcpy(error,"error in line ");
                        sprintf(stringNumber, "%d", countLineNumber);
                        strcat(error,stringNumber);
                        strcat(error," : integer constant is out of range\n");
                        fprintf(yyout,"%s",error);
                      }
                    else {
                        strcpy(line,"TOKEN_INTCONST ");
                        strcat(line,yytext);
                        strcat(line,"\n");
                        fprintf(yyout,"%s",line);
                      }
                    }

[\t]                   {
                    strcpy(line,"TOKEN_WHITESPACE \\t [tab]\n");
                    fprintf(yyout,"%s",line);
                    }

[.]*[\n]              {
                    strcpy(line,"TOKEN_WHITESPACE \\n [newLine]\n");
                    fprintf(yyout,"%s",line);
                    countLineNumber++;
                    }

"+"                {
                    strcpy(line,"TOKEN_ARITHMATICOP +\n");
                    fprintf(yyout,"%s",line);
                    }

"-"                {
                    strcpy(line,"TOKEN_ARITHMATICOP -\n");
                    fprintf(yyout,"%s",line);
                    }

"/"                {
                    strcpy(line,"TOKEN_ARITHMATICOP /\n");
                    fprintf(yyout,"%s",line);
                    }

"&&"                {
                    strcpy(line,"TOKEN_LOGICOP &&\n");
                    fprintf(yyout,"%s",line);
                    }

"&"                {
                    strcpy(line,"TOKEN_BITWISEOP &\n");
                    fprintf(yyout,"%s",line);
                    }

"|"                {
                    strcpy(line,"TOKEN_BITWISEOP |\n");
                    fprintf(yyout,"%s",line);
                    }

"||"                {
                    strcpy(line,"TOKEN_LOGICOP ||\n");
                    fprintf(yyout,"%s",line);
                    }

"=<"                {
                    strcpy(line,"TOKEN_RELATIONOP =<\n");
                    fprintf(yyout,"%s",line);
                    }

"<"                {
                    strcpy(line,"TOKEN_RELATIONOP <\n");
                    fprintf(yyout,"%s",line);
                    }

">"                {
                    strcpy(line,"TOKEN_RELATIONOP >\n");
                    fprintf(yyout,"%s",line);
                    }
"="              {
                    strcpy(line,"TOKEN_ASSIGNOP =\n");
                    fprintf(yyout,"%s",line);
                  }
"=>"                {
                    strcpy(line,"TOKEN_RELATIONOP =>\n");
                    fprintf(yyout,"%s",line);
                    }
"=="                {
                    strcpy(line,"TOKEN_RELATIONOP ==\n");
                    fprintf(yyout,"%s",line);
                    }
"=!"                {
                    strcpy(line,"TOKEN_RELATIONOP =!\n");
                    fprintf(yyout,"%s",line);
                    }
"^"                {
                    strcpy(line,"TOKEN_ARITHMATICOP ^\n");
                    fprintf(yyout,"%s",line);
                    }
"!"                {
                    strcpy(line,"TOKEN_LOGICOP !\n");
                    fprintf(yyout,"%s",line);
                    }

"("              {
                    strcpy(line,"TOKEN__LEFTPAREN \(\n");
                    fprintf(yyout,"%s",line);
                  }

")"              {
                    strcpy(line,"TOKEN_REIGHTPAREN )\n");
                    fprintf(yyout,"%s",line);
                  }

"{"                {
                    strcpy(line,"TOKEN_LCB 	{\n");
                    fprintf(yyout,"%s",line);
                    }

"}"                  {
                    strcpy(line,"TOKEN_RCB }\n");
                    fprintf(yyout,"%s",line);
                    }
";"                   {
                    strcpy(line,"TOKEN_SEMICOLON ;\n");
                    fprintf(yyout,"%s",line);
                    }

","                {
                    strcpy(line,"TOKEN_COMMA ,\n");
                    fprintf(yyout,"%s",line);
                    }

".."                {
                    strcpy(line,"TOKEN_UNTIL ..\n");
                    fprintf(yyout,"%s",line);
                    }

"["                {
                    strcpy(line,"TOKEN_LB [\n");
                    fprintf(yyout,"%s",line);
                    }

"]"                {
                    strcpy(line,"TOKEN_RB ]\n");
                    fprintf(yyout,"%s",line);
                    }

[0-9]+[\.][0-9]+    {
                    strcpy(line,"TOKEN_FLOATCONST ");
                    strcat(line,yytext);
                    strcat(line,"\n");
                    fprintf(yyout,"%s",line);
                    }

["][a-zA-z0-9]*["]   {
                    strcpy(line,"TOKEN_STRINGCONST ");
                    strcat(line,yytext);
                    strcat(line,"\n");
                    fprintf(yyout,"%s",line);
                    }
['][a-zA-z0-9][']   {
                    strcpy(line,"TOKEN_CHARCONST ");
                    strcat(line,yytext);
                    strcat(line,"\n");
                    fprintf(yyout,"%s",line);
                    }

[0-9]+[0-9a-zA-Z|_|-]*   {
                      printf("\033[1;31merror \033[0min line %d : wrong id definition\n",countLineNumber);
                      strcpy(error,"error in line ");
                      sprintf(stringNumber, "%d", countLineNumber);
                      strcat(error,stringNumber);
                      strcat(error," : wrong id definition\n");
                      fprintf(yyout,"%s",error);
                    }

[a-zA-Z]+[0-9a-zA-Z|_|-]*    {

                    if (yyleng > 31){
                      printf("\033[1;31merror \033[0min line %d : size of variable is out of range\n",countLineNumber);
                      strcpy(error,"error in line ");
                      sprintf(stringNumber, "%d", countLineNumber);
                      strcat(error,stringNumber);
                      strcat(error," : size of variable is out of range\n");
                      fprintf(yyout,"%s",error);
                    }
                    else {
                    strcpy(line,"TOKEN_ID ");
                    strcat(line,yytext);
                    strcat(line,"\n");
                    fprintf(yyout,"%s",line);
                  }
                    }
%%

int main (){
  FILE *f = fopen("testcases.txt","r");
  yyin = f;

  FILE *fb = fopen("SymbolTable.txt", "w");
  yyout = fb;

  yylex();
  return 0;
}
