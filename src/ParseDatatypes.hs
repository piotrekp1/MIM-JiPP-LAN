module ParseDatatypes where
import Datatypes

data PExp
      = Let String PExp PExp
      | Exp1 Exp1
      deriving Show

data Exp1
      = E1Op Op Exp1 Exp1
      | Term Term
      deriving Show

data Term
      = Factor Factor
      | TOp Op Term Factor
      deriving Show

data Factor
      = Int Int
      | Var String
      | Brack PExp
      deriving Show

data PBlock
    = PBegin PDecl PSntnc
    | PDecl PDecl
    | PSntnc PSntnc
    deriving Show

data PSntnc
    = PSkip
    | PScln PSntnc PSntnc
    | PExp0 PExp0
      deriving Show

data PExp0
    = PAsgn Var PExp0
    | PIfStmt BExp1 PExp0 PExp0
    | PWhile BExp1 PExp0
    | PExp PExp
    | SntBrack PSntnc
    deriving Show

data PDecl
    = PDSkip
    | PSingDecl Var Datatype
    | PDScln PDecl PDecl
    deriving Show

data BExp1
    = Or BExp1 BExp1
    | BExp2 BExp2
    deriving Show

data BExp2
    = And BExp2 BExp2
    | BBrack BExp1
    | PCmp PCmp
    | BVal Bool
    deriving Show

data PCmp
    = PCmpExp Ordering PExp PExp
    deriving Show