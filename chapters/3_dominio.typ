#import "../config/glossario-data.typ": gls

#pagebreak(to:"odd")

= Studio del dominio

Durante la prima fase del tirocinio è stato fatto uno studio approfondito sul tema del #gls("vulnerability-assessment"), attraverso il quale sono stati compresi i termini chiave del dominio, le principali problematiche e le soluzioni che le aziende prendono in considerazione per gestire al meglio il tracciamento e risoluzione di vulnerabilità.
Come riporta @rajamani2025, nel solo 2025 sono state pubblicate 48.185 #gls("cve"), di cui il 56% classificate come high o critical, rendendo la coda di #gls("remediation") ingestibile senza un triage intelligente.
Questa eccessiva segnalazione di vulnerabilità porta ad un fenomeno chiamato #gls("vulnerability-fatigue") che induce gli analisti a non svolgere in modo efficace la loro gestione.
Per questo motivo occorre adottare un framework #gls("ctem") (Continuous Threat Exposure Management) e affidarsi ad un ampio ventaglio di metriche per poter constestualizzare al meglio le #gls("cve") ed ottimizzare la loro risuluzione, dando priorità ad un ristretto e mirato numero di vulnerabilità.

La piattaforma di ThreatLens si sviluppa in questo contesto e intende ottenere da un indirizzo IP una lista di #gls("cve") utilizzando scanner professionali di terze parti come #gls("qualys"), alla quale aggiunge una serie di altre metriche fornendo un dettagliato e attendibile contesto facilmente interpretabile da un analista di sicurezza.
La piattaforma funge da motore di prioritizzazione intelligente: valuta il rischio operativo di ogni singola #gls("cve") e impiega l'Intelligenza Artificiale per generare una spiegazione chiara e sintetica delle metriche rilevate. In questo modo, il sistema non si sostituisce all'analista nella decisione finale, ma gli fornisce un quadro contestualizzato e argomentato, permettendogli di validare rapidamente le informazioni proposte e procedere in modo tempestivo con la corretta #gls("remediation").

== Limiti del CVSS

La metrica principale per classificare una #gls("cve") è il #gls("cvss"), uno standard sviluppato dal FIRST (la principale organizzazione globale no-profit dedicata alla risposta degli incidenti informatici) che indica da 1.0 a 10.0 la gravità di una vulnerabilità.
Questa metrica tuttavia risponde alla domanda sbagliata per il #gls("triage"): dice quanto sarebbe grave una vulnerabilità se sfruttata, non quanto è probabile che venga sfruttata in tempi utili per decidere il #gls("patching").
In @VMC viene detto che la metrica #gls("cvss") è stata creata solo per misurare il massimo impatto teorico possibile invece di un rischio nel mondo reale, non considerando la probabilità che essa venga usata e il rischio pesato in un preciso contesto.
Già da tempo ci sono articoli come @ImprovingCvss che indicano come i punteggi #gls("cvss"), senza informazione sull'ambiente in cui si presenta la vulnerabilità, hanno utilità limitata per una prioritizzazione pratica e aggiungere del contesto migliorerebbe significativamente la selezione delle risposte.

Un secondo problema di questa metrica è la scarsa azionabilità del punteggio. Il #gls("cvss") concentra molte vulnerabilità nelle fasce alte, con uno score superiore al 7.0, rendendo difficile la priorità di #emph("remediation") e aumentando il fenomeno di #gls("vulnerability-fatigue").

== Nuove metriche supportate dalla letteratura scientifica

La soluzione sarebbe integrare nella prioritizzazione una serie di altre metriche per sopperire ai problemi sopra descritti. 
Un dato significativo è l'#gls("epss") che utilizza il machine learning e #emph("threat intelligence data") per stimare la probabilità che una vulnerabilità venga sfruttata entro 30 giorni, mentre il #gls("kev") indica se sono state registrate evidenze di exploit confermato.
Secondo @VMC, mentre un filtro basato esclusivamente sul CVSS presenta un'efficienza operativa di appena lo 0,5% (generando un elevato rumore di fondo), il modello combinato innalza la precisione al 9,1%. Questo permette di concentrare gli sforzi operativi sulle minacce reali, mantenendo al contempo una copertura (coverage) dell'85,6% sulle vulnerabilità effettivamente sfruttate.

#image("/images/VMC.png")



== Il modello Vulnerability Management Chaining

Spiegazione dell'albero decisionale messo nel paper
Analisi dei risultati trovati nel paper
Spiegazione di tag decision making con metriche cisia e del perchè siano usate