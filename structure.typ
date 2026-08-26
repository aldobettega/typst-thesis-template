// Frontmatter
#include "./preface/firstpage.typ"
#include "./preface/copyright.typ"
// #include "./preface/dedication.typ"
#include "./preface/summary.typ"
//  #include "./preface/acknowledgements.typ"
#include "./preface/table-of-contents.typ"

// Mainmatter
#counter(page).update(1)

#include "chapters/1_introduzione.typ"
#include "chapters/2_processi.typ"
#include "chapters/3_dominio.typ"
#include "chapters/4_analisi_requisiti.typ"
#include "chapters/5_tecnologie.typ"
#include "chapters/6_ambiente_di_test.typ"
#include "chapters/7_progettazione_architetturale.typ"
#include "chapters/8_codifica.typ"
#include "chapters/9_ai.typ"
#include "chapters/10_conclusioni.typ"

// Appendix
// #include "./appendix/appendice-a.typ"

// Backmatter
#include "./appendix/glossario.typ"

// Bibliography
#include "./appendix/bibliography/bibliography.typ"