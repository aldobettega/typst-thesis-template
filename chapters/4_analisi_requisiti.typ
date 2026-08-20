#import "../config/glossario-data.typ": gls

= Analisi dei requisiti

== Studio del dominio

Durante la prima fase del tirocinio è stato fatto uno studio approfondito sul tema del #gls("vulnerability-assessment"), attraverso il quale sono stati compresi i termini chiave del dominio, le principali problematiche e le soluzioni che le aziende prendono in considerazione per gestire al meglio il tracciamento e risoluzione di vulnerabilità.
Come riporta @rajamani2025, nel solo 2025 sono state pubblicate 48.185 #gls("cve"), di cui il 56% classificate come high o critical, rendendo la coda di #gls("remediation") ingestibile senza un triage intelligente.
Questa eccessiva segnalazione di vulnerabilità porta ad un fenomeno chiamato #gls("vulnerability-fatigue") che induce gli analisti a non svolgere in modo efficace la loro gestione.
Per questo motivo occorre adottare un framework #gls("ctem") (Continuous Threat Exposure Management) e affidarsi ad un ampio ventaglio di metriche per poter constestualizzare al meglio le #gls("cve") ed ottimizzare la loro risuluzione, dando priorità ad un ristretto e mirato numero di vulnerabilità.

La piattaforma di ThreatLens si sviluppa in questo contesto e intende ottenere da un indirizzo IP una lista di #gls("cve") utilizzando scanner professionali di terze parti come #gls("qualys"), alla quale aggiunge una serie di altre metriche fornendo un dettagliato e attendibile contesto facilmente interpretabile da un analista di sicurezza.
La piattaforma funge da motore di prioritizzazione intelligente: valuta il rischio operativo di ogni singola #gls("cve") e impiega l'Intelligenza Artificiale per generare una spiegazione chiara e sintetica delle metriche rilevate. In questo modo, il sistema non si sostituisce all'analista nella decisione finale, ma gli fornisce un quadro contestualizzato e argomentato, permettendogli di validare rapidamente le informazioni proposte e procedere in modo tempestivo con la corretta #gls("remediation").


== Casi d'uso

== Tracciamento dei requisiti