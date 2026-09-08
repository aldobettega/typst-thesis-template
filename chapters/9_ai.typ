#pagebreak(to:"odd")

#import "../config/glossario-data.typ": gls

= Integrazione dell'Intelligenza\ Artificiale

L'obiettivo dell'integrazione di un Modello Linguistico all'interno di ThreatLens non è delegare un calcolo del rischio classificando la #gls("cve"), ma rielaborare tutti i dati ricavati dai vari provider in una sintesi in linguaggio naturale dando un chiaro contesto all'analista di sicurezza.
All'intelligenza artificiale è stata data la direttiva di agire come un analista di #emph("cybersecurity") senior.

Per ottenere risultati affidabili, coerenti e privi di #gls("allucinazioni"), è stata strutturata in input una direttiva che utilizza tecniche di #emph[#gls("prompt-engeneering")] con un'infrastruttura di validazione dell'output rigorosa.

== Strutturazione del Contesto e #gls("prompt") Engineering

Il #gls("prompt") inviato all'#gls("llm") non è una semplice stringa testuale, ma un #gls("payload") JSON strutturato che incapsula in modo ordinato tutte le metriche elaborate dalla #gls("pipeline"). Al seguito di attente ricerche è stato infatti trovato che il formato più leggibile da un #gls("llm") è il JSON, perchè consente di strutturare il #gls("prompt") in chiavi-valori che aiutano il modello nella comprensione della direttiva e aumentano le performance di risposta in output.
Il prompt risiede in un file dedicato che è composto dalle seguenti sezioni:

- *Detection Evidence:* Contiene le evidenze puramente tecniche rilevate dallo scanner (es. #gls("qualys")) sullo specifico asset. Il modello è istruito a distinguere rigorosamente tra ciò che è stato effettivamente osservato (host, porte, stato della rilevazione) e la documentazione generale della vulnerabilità fornita dal vendor.
- *CVE Evidence:* Include le metriche oggettive associate alla specifica #gls("cve") (punteggio #gls("cvss"), stima #gls("epss") e presenza nel catalogo #gls("kev")). Il #gls("prompt") fornisce direttive esplicite su come interpretare questi segnali: ad esempio, l'assenza della vulnerabilità dal catalogo del #gls("kev") non indica sistematicamente che questa non sia mai stata sfruttata.
- *ThreatLens Assessment:* Rappresenta il risultato calcolato dal `PriorityEngine`. Al modello viene vietato di ricalcolare, correggere o alterare la priorità calcolata dal sistema, limitando il suo ruolo alla sola spiegazione delle motivazioni che hanno portato a tale risultato.

== Analisi dell'Allineamento

Una delle criticità principali è stata la frequente discordanza tra la gravità assegnata dallo scanner enterprise di terze parti e la priorità calcolata dal motore interno.
Per gestire questa problematica, il sistema calcola a priori una metrica definita #emph("Alignment Observation"), la quale confronta quantitativamente le due valutazioni incasellandole in categorie predefinite (es. valutazioni allineate verso l'alto, oppure rischio dello scanner elevato ma priorità calcolata inferiore). Questa classificazione viene passata al modello AI con regole rigorose: in caso di divergenza, l'IA deve spiegare naturalmente la differenza osservabile chiarendo che i due sistemi valutano metriche differenti, senza mai presentare tale discordanza come un errore tecnico.
In questo modo verrà posta l'attenzione dell'analista sui motivi di disallineamento delle due metriche dando, tramite questo confronto, ulteriore contesto all'analisi.

== Vincoli di Output e Prevenzione delle #gls("allucinazioni")

Affinchè la risposta sia utilizzabile dal #gls("frontend"), il sistema impone che l'output finale sia privo di formattazioni esterne (come il Markdown).

La struttura dell'output è rigidamente tipizzata e richiede la generazione di campi specifici per ogni vulnerabilità analizzata:
- *Summary:* Una sintesi interpretativa.
- *Detection Context & Priority Rationale:* La contestualizzazione tecnica e la spiegazione della priorità.
- *Alignment Explanation:* La spiegazione dell'eventuale disallineamento tra lo scanner e ThreatLens.
- *Documented Action:* Le azioni di mitigazione concrete, estraendo solo dati reali senza inventare comandi o procedure non documentate.
- *Uncertainty:* L'esplicitazione formale del limite informativo più rilevante per il caso in esame.

Per limitare ulteriormente il fenomeno delle #gls("allucinazioni"), il #gls("prompt") include una  serie di limiti comportamentali. Al modello sono stati imposti dei divieti come affermare che un asset sia compromesso in assenza di prove o di introdurre informazioni esterne non presenti nel #gls("payload") partenza. 