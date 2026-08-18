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
#include "chapters/3_analisi_requisiti.typ"
#include "chapters/4_tecnologie.typ"
#include "chapters/5_ambiente_di_test.typ"
#include "chapters/6_progettazione_architetturale.typ"
#include "chapters/7_ai.typ"
#include "chapters/8_problematiche_incontrate.typ"
#include "chapters/9_conclusioni.typ"

// // Appendix

// #include "./appendix/appendice-a.typ"

// // Backmatter

// // Praticamente il glossario

// Bibliography

#include("./appendix/bibliography/bibliography.typ")
