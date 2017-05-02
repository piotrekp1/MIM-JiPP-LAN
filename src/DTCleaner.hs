module DTCleaner where
import ParseDatatypes
import SemanticDatatypes
import Datatypes

semPExp :: PExp -> Exp
semPExp (Let str pexp1 pexp2) = ELet str (semPExp pexp1) (semPExp pexp2)
semPExp (Exp1 pexp) = semExp1 pexp

semExp1 :: Exp1 -> Exp
semExp1 (E1Op op exp1_1 exp1_2) = EOp op (semExp1 exp1_1) (semExp1 exp1_2)
semExp1 (Term term) = semTerm term

semTerm :: Term -> Exp
semTerm (TOp op term factor) = EOp op (semTerm term) (semFact factor)
semTerm (Factor factor) = semFact factor

semFact :: Factor -> Exp
semFact (Int a) = EInt a
semFact (Var varName) = EVar varName
semFact (Brack pexp) = semPExp pexp


semPBlock :: PBlock -> Exp
semPBlock (PBegin pdecl psntnc) = SBegin (semPDecl pdecl) (semPSntnc psntnc)
semPBlock (PDecl pdecl) = SBegin (semPDecl pdecl) Skip
semPBlock (PSntnc psntnc) = semPSntnc psntnc

semPSntnc :: PSntnc -> Exp
semPSntnc (PSkip) = Skip
semPSntnc (PScln psntnc1 psntnc2) = SScln (semPSntnc psntnc1) (semPSntnc psntnc2)
semPSntnc (PExp0 pexp0) = semPStmt pexp0


semPStmt :: PExp0 -> Exp
semPStmt (PAsgn var pexp) = SAsgn var $ semPStmt pexp
semPStmt (PIfStmt pbexp pstmt1 pstmt2) = SIfStmt (semPBexp1 pbexp) (semPStmt pstmt1) (semPStmt pstmt2)
semPStmt (PWhile pexp pstmt) = SWhile (semPBexp1 pexp) (semPStmt pstmt)
semPStmt (PExp pexp) = semPExp pexp
semPStmt (SntBrack psntnc) = semPSntnc psntnc


semPDecl :: PDecl -> Decl
semPDecl (PDSkip) = DSkip
semPDecl (PSingDecl var datatype) = DDecl var datatype
semPDecl (PDScln pdecl1 pdecl2) = DScln (semPDecl pdecl1) (semPDecl pdecl2)


semPBexp1 :: BExp1 -> BExp
semPBexp1 (Or bexp1_1 bexp1_2) = BEOp OpOr (semPBexp1 bexp1_1) (semPBexp1 bexp1_2)
semPBexp1 (BExp2 bexp2) = semPBexp2 bexp2

semPBexp2 :: BExp2 -> BExp
semPBexp2 (And bexp1_1 bexp1_2) = BEOp OpAnd (semPBexp2 bexp1_1) (semPBexp2 bexp1_2)
semPBexp2 (BBrack bexp1) = semPBexp1 bexp1
semPBexp2 (BVal bval) = BEBool bval
semPBexp2 (PCmp pcmp) = semPCmp pcmp

semPCmp :: PCmp -> BExp
semPCmp (PCmpExp comp pexp1 pexp2) = BCmp comp (semPExp pexp1) (semPExp pexp2)

