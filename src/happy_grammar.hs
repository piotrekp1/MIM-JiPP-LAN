{
module Parser (getTree) where
import Data.Char
import ParseDatatypes
import Datatypes
}

%name lang
%tokentype { Token }
%error { parseError }


%token
      let             { TokenLet }
      in              { TokenIn }
      int             { TokenInt $$ }
      bool            { TokenBool $$ }
      var             { TokenVar $$ }
      '='             { TokenEq }
      '+'             { TokenPlus }
      '-'             { TokenMinus }
      '*'             { TokenTimes }
      '/'             { TokenDiv }
      '('             { TokenOB }
      ')'             { TokenCB }
      '&'             { TokenAnd }
      '|'             { TokenOr }
%%

PExp  : let var '=' PExp in PExp{ Let $2 $4 $6 }
      | Exp1                    { Exp1 $1 }

Exp1  : Exp1 '+' Exp1           { E1Op OpAdd $1 $3 }
      | Exp1 '-' Exp1           { E1Op OpSub $1 $3 }
      | Term                    { Term $1 }

Term  : Term '*' Factor         { TOp OpMul $1 $3 }
      | Term '/' Factor         { TOp OpDiv $1 $3 }
      | Factor                  { Factor $1 }

Factor
      : int                     { Int $1 }
      | var                     { Var $1 }
      | '(' PExp ')'             { Brack $2 }


{-

BExp  : bool                      { BEBool $1 }
      | BExp Op BExp              { BEOp $2 $1 $3 }
      | var                       { BEVar $1 }
      | let var '=' BExp in BExp  { BELet $2 $4 $6 }

Op    : '&'                      { OpAnd }
      | '|'                      { OpOr }
-}

{

parseError :: [Token] -> a
parseError list = error ("Parse error" ++ show list)

data Token
      = TokenLet
      | TokenIn
      | TokenInt Int
      | TokenBool Bool
      | TokenVar String
      | TokenEq
      | TokenPlus
      | TokenMinus
      | TokenTimes
      | TokenDiv
      | TokenOB
      | TokenCB
      | TokenAnd
      | TokenOr
 deriving Show

lexer :: String -> [Token]
lexer [] = []
lexer (c:cs)
      | isSpace c = lexer cs
      | isAlpha c = lexVar (c:cs)
      | isDigit c = lexNum (c:cs)
lexer ('=':cs) = TokenEq : lexer cs
lexer ('+':cs) = TokenPlus : lexer cs
lexer ('-':cs) = TokenMinus : lexer cs
lexer ('*':cs) = TokenTimes : lexer cs
lexer ('/':cs) = TokenDiv : lexer cs
lexer ('(':cs) = TokenOB : lexer cs
lexer (')':cs) = TokenCB : lexer cs
lexer ('&':cs) = TokenAnd : lexer cs
lexer ('|':cs) = TokenOr : lexer cs

numBool :: Int -> Bool
numBool 1 = True
numBool 0 = False

lexNum cs = TokenInt (read num) : lexer rest
      where (num,rest) = span isDigit cs
{-


lexBool cs = TokenBool (numBool $ read num) : lexer rest
      where (num,rest) = span isDigit cs
-}

lexVar cs =
   case span isAlpha cs of
      ("let",rest) -> TokenLet : lexer rest
      ("in",rest)  -> TokenIn : lexer rest
      (var,rest)   -> TokenVar var : lexer rest

--main = getContents >>= print . calc . lexer
getTree = lang . lexer
}