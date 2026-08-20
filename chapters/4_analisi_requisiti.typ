#import "../config/thesis-config.typ": useCase

#pagebreak(to:"odd")

= Analisi dei Requisiti

A seguito dello studio del dominio del problema e della definizione dei processi aziendali, si è proceduto all'elicitazione e alla formalizzazione dei requisiti del sistema. La piattaforma è concepita come uno strumento di orchestrazione, arricchimento e prioritizzazione, il cui scopo è trasformare un input grezzo in un report operativo (VulnerabilityReport) esposto tramite un'interfaccia web.

== Requisiti Funzionali

I requisiti funzionali definiscono le operazioni fondamentali che il sistema deve garantire per soddisfare i casi d'uso previsti (UC1 - UC10).

- *Orchestrazione della scansione:* Il sistema deve permettere all'analista di sicurezza di avviare una nuova analisi specificando un IP target e un contesto (Asset Context), per poi interfacciarsi con uno scanner esterno per l'esecuzione.
- *Normalizzazione e deduplicazione:* Il sistema deve acquisire i risultati grezzi (es. host, porta, servizio, severità) dallo scanner e convertirli in un modello interno unificato (UnifiedFinding), consolidando eventuali vulnerabilità duplicate.
- *Arricchimento evidence-based (Enrichment):* Il sistema deve interrogare provider esterni per arricchire ogni vulnerabilità (CVE) con dati contestuali: CVSS (da NVD), EPSS (da FIRST) e KEV (da CISA).
- *Calcolo della priorità operativa:* Il motore di prioritizzazione (Priority Engine) deve calcolare una classe di priorità (es. Track, Attend, Act) basandosi sui dati arricchiti (severity, probabilità di exploit, evidenza KEV) e sull'esposizione dell'asset, senza limitarsi alla severità tecnica statica.
- *Spiegazione intelligente (Explainability):* A valle della prioritizzazione, il sistema deve utilizzare un LLM per generare una spiegazione testuale che motivi all'analista le ragioni della priorità assegnata.
- *Reporting e visualizzazione:* Il sistema deve generare un documento finale aggregato e confrontabile con una baseline tradizionale, visualizzabile direttamente tramite interfaccia grafica ed esportabile.

== Requisiti Non Funzionali

I requisiti non funzionali definiscono gli standard di qualità, performance e comportamento che il sistema deve rispettare.

- *Resilienza (Graceful Degradation):* La generazione delle spiegazioni AI costituisce un layer accessorio. Nel caso in cui il provider LLM fallisca o non sia raggiungibile, il sistema deve ignorare l'errore e garantire comunque la generazione del report prioritizzato.
- *Efficienza tramite Bulk Processing:* Le interrogazioni ai provider esterni (CVSS, EPSS, KEV, AI) non devono avvenire iterando sui singoli elementi, ma devono elaborare liste in modalità *bulk* al fine di ridurre latenza e chiamate esterne.
- *Estendibilità Scanner-Agnostic:* Pur prevedendo l'integrazione esclusiva con Qualys nella versione MVP, il design deve supportare l'estensione futura a nuovi scanner (es. Nessus, OpenVAS) senza impattare la pipeline centrale di arricchimento e prioritizzazione.

== Vincoli Architetturali e Tecnologici

Per limitare la complessità e garantire la manutenibilità (privilegiando un approccio *backend source of truth*), il sistema impone severi vincoli a livello architetturale e implementativo.

- *Architettura Backend:* Il sistema adotta il pattern Ports & Adapters (Hexagonal Architecture) in ambiente Python 3.12, isolando il dominio dalle sorgenti dati e utilizzando Pydantic per i contratti API.
- *Separazione delle responsabilità dell'AI:* L'Intelligenza Artificiale opera esclusivamente come motore di *explainability*. Non può e non deve partecipare in alcun modo al calcolo o alla decisione della priorità operativa (Decision Making).
- *Limiti di responsabilità del Frontend:* Il client web (TypeScript/React) deve fungere da layer di visualizzazione. È fatto esplicito divieto di inserire logiche di dominio, ViewModel aggiuntivi, mapper o DTO intermedi nel frontend. Il client deve consumare direttamente lo schema API JSON esposto dal backend.


== Casi d'uso del sistema

Al fine di modellare compiutamente il comportamento del sistema e delineare le interazioni tra gli attori (umani, componenti interni e provider esterni), sono stati formalizzati i seguenti casi d'uso (UC) principali. La piattaforma è progettata come una *pipeline* automatizzata, motivo per cui la maggior parte delle interazioni ha come attore principale il Backend stesso.

#useCase((
  number: "1",
  name: "Creazione e avvio scansione Qualys",
  "Attore principale": "Analista di sicurezza",
  "Attore secondario": "Scanner Qualys",
  "Precondizione": "L'utente è autenticato nella piattaforma.",
  "Flusso principale": "L'utente inserisce uno o più IP target, associa un contesto agli asset (environment, exposure, criticality) e avvia l'analisi. Il backend valida i dati e invia la richiesta allo scanner.",
  "Postcondizione": "La scansione è avviata o agganciata correttamente."
))

#v(1em)

#useCase((
  number: "2",
  name: "Monitoraggio scansione",
  "Attore principale": "Backend della piattaforma",
  "Flusso principale": "Il sistema interroga periodicamente lo scanner per verificarne lo stato (in coda, in esecuzione, completata o fallita) e aggiorna l'interfaccia utente in tempo reale.",
  "Postcondizione": "Il sistema dispone dei risultati grezzi pronti per il recupero."
))

#v(1em)

#useCase((
  number: "3",
  name: "Acquisizione risultati Qualys",
  "Attore principale": "Backend della piattaforma",
  "Flusso principale": "A scansione terminata, il backend recupera i finding generati estraendo i dati tecnici fondamentali (QID, CVE, host, porta, servizio e severità).",
  "Postcondizione": "I dati grezzi sono salvati e disponibili per la successiva fase di normalizzazione."
))

#v(1em)

#useCase((
  number: "4",
  name: "Normalizzazione e Deduplicazione",
  "Attore principale": "Backend della piattaforma",
  "Flusso principale": "Il sistema analizza i finding, identifica eventuali duplicati interni (stessa CVE sul medesimo host e servizio) e li consolida in un modello dati unificato e agnostico (UnifiedFinding).",
  "Postcondizione": "Si ottiene una lista consolidata e priva di ridondanze."
))

#v(1em)

#useCase((
  number: "5",
  name: "Arricchimento evidence-based",
  "Attore principale": "Backend della piattaforma",
  "Attori secondari": "Provider esterni (NVD, FIRST EPSS, CISA KEV)",
  "Flusso principale": "Ogni finding viene arricchito interrogando fonti autorevoli esterne per ottenere metriche CVSS, stima probabilistica EPSS, evidenza in KEV e associazione definitiva con l'Asset Context.",
  "Postcondizione": "Ogni vulnerabilità dispone di informazioni tecniche, segnali di exploitability e contesto operativo."
))

#v(1em)

#useCase((
  number: "6",
  name: "Calcolo della priorità operativa",
  "Attore principale": "Backend della piattaforma (Priority Engine)",
  "Flusso principale": "Il motore di prioritizzazione calcola uno score che integra severità tecnica, probabilità di exploit, evidenze KEV ed esposizione dell'asset, assegnando una categoria operativa finale (Track, Attend, Act).",
  "Postcondizione": "Il sistema dispone di un ranking ordinato non basato solo su regole statiche."
))

#v(1em)

#useCase((
  number: "7",
  name: "Confronto con baseline tradizionale",
  "Attore principale": "Backend della piattaforma",
  "Flusso principale": "Il sistema genera un ranking basato esclusivamente sulla severità CVSS/Qualys e lo confronta con la nuova priorità calcolata, tracciando variazioni, declassamenti e shift di priorità.",
  "Postcondizione": "L'analista può quantificare e verificare metricamente l'efficacia del nuovo modello."
))

#v(1em)

#useCase((
  number: "8",
  name: "Generazione spiegazioni tramite AI",
  "Attore principale": "Provider LLM (Intelligenza Artificiale)",
  "Precondizione": "Le vulnerabilità sono già state analizzate, arricchite e prioritizzate in modo definitivo dal backend.",
  "Flusso principale": "Il sistema fornisce all'AI un payload JSON rigoroso contenente le metriche. L'AI genera una sintesi testuale che motiva all'utente umano le ragioni della specifica priorità assegnata.",
  "Postcondizione": "Il report si arricchisce di spiegazioni leggibili in linguaggio naturale."
))

#v(1em)

#useCase((
  number: "9",
  name: "Generazione ed esportazione report",
  "Attore principale": "Backend della piattaforma",
  "Flusso principale": "Il sistema aggrega i finding, le priorità, i delta rispetto alla baseline e le spiegazioni dell'AI in un documento deterministico consultabile nell'interfaccia ed esportabile in formato PDF/Word.",
  "Postcondizione": "L'analisi è formalmente conclusa e storicizzata."
))

#v(1em)

#useCase((
  number: "10",
  name: "Estendibilità verso nuovi scanner",
  "Attore principale": "Sviluppatore / Manutentore",
  "Flusso principale": "Sfruttando il pattern ad *Adapter*, il sistema permette l'aggiunta di nuovi moduli per scanner futuri (es. Nessus, OpenVAS) mappando i loro output sul modello interno *UnifiedFinding*.",
  "Postcondizione": "La pipeline centrale rimane intatta a prescindere dal vendor dello scanner."
))