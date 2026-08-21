#import "../config/thesis-config.typ": useCase
#import "../config/glossario-data.typ": gls

#pagebreak(to:"odd")

= Analisi dei Requisiti

A seguito dello studio del dominio del problema e della definizione dei processi aziendali, si è proceduto alla definizione dei casi d'uso e alla conseguente stesura dei requisiti di sistema.

== Casi d'uso del sistema

#useCase((
  number: "1",
  name: "Creazione e avvio dell'analisi di sicurezza",
  "Attore principale": "Utente",
  "Attore secondario": "Scanner",
  "Precondizione": "L'utente si trova all'interno della piattaforma nella sezione di nuova analisi.",
  "Flusso principale": "L'utente configura i parametri fondamentali per la scansione (scanner, target, contesto) e ne richiede l'avvio. Il sistema convalida i dati in ingresso e avvia l'analisi.",
  "Sottocasi inclusi": "UC1.1 (Selezione scanner), UC1.2 (Inserimento IP), UC1.3 (Definizione Asset Context).",
  "Postcondizione": "La scansione è avviata correttamente e il sistema entra in fase di elaborazione."
))

#v(1em)

#useCase((
  number: "1.1",
  name: "Selezione dello scanner",
  "Attore principale": "Utente",
  "Flusso principale": "L'utente seleziona lo scanner da utilizzare per l'analisi. Attualmente il sistema vincola la selezione all'unica opzione supportata (Qualys)."
))

#v(1em)

#useCase((
  number: "1.2",
  name: "Inserimento IP target",
  "Attore principale": "Utente",
  "Flusso principale": "L'utente inserisce un singolo indirizzo IP che rappresenta il target su cui effettuare l'analisi delle vulnerabilità."
))

#v(1em)

#useCase((
  number: "1.3",
  name: "Definizione dell'Asset Context",
  "Attore principale": "Utente",
  "Flusso principale": "L'utente seleziona i tre parametri di contesto necessari a delineare il profilo di rischio del target: ambiente (environment), esposizione (exposure) e criticità (criticality)."
))

#v(1em)

#useCase((
  number: "2",
  name: "Monitoraggio dell'avanzamento dell'analisi",
  "Attore principale": "Utente",
  "Flusso principale": "L'utente visualizza l'interfaccia dedicata allo stato dell'analisi. Il sistema interroga lo scanner e mostra in tempo reale l'avanzamento del processo (scansione in corso, recupero di dati, generazione AI o pipeline fallita).",
  "Postcondizione": "L'utente è costantemente informato sullo stato di completamento del task."
))

#v(1em)

#useCase((
  number: "3",
  name: "Apertura e consultazione del report di vulnerabilità",
  "Attore principale": "Utente",
  "Precondizione": "L'utente richiede l'accesso ai risultati di una specifica analisi.",
  "Flusso principale": "Il sistema recupera il report e presenta un Vulnerability Report aggregato che include le vulnerabilità, la loro priorità operativa e la spiegazione generata dall'AI.",
  "Sottocasi inclusi": "UC3.1 (Report non disponibile)",
  "Postcondizione": "L'utente dispone delle metriche contestuali per prendere una decisione operativa sulle remediation."
))

#v(1em)

#useCase((
  number: "3.1",
  name: "Report non disponibile",
  "Attore principale": "Utente",
  "Flusso principale": "Qualora l'analisi non sia ancora terminata, sia fallita durante la pipeline o il report richiesto non esista nel sistema, viene mostrato un avviso a schermo che comunica esplicitamente che il report non è disponibile.",
  "Postcondizione": "L'utente è informato dell'indisponibilità del dato."
))

#v(1em)

#useCase((
  number: "4",
  name: "Esportazione del report",
  "Attore principale": "Utente",
  "Precondizione": "L'utente sta visualizzando un report completato e accessibile.",
  "Flusso principale": "L'utente richiede l'esportazione del report. Il sistema compila un documento in formato DOCX contenente il dettaglio tecnico delle vulnerabilità e lo rende disponibile per il download.",
  "Sottocasi inclusi": "UC4.1 (Fallimento esportazione)",
  "Postcondizione": "Viene scaricato il file DOCX del report."
))

#v(1em)

#useCase((
  number: "4.1",
  name: "Fallimento esportazione del report",
  "Attore principale": "Utente",
  "Flusso principale": "Se il processo di compilazione del file DOCX o il suo salvataggio incontrano un'eccezione, il sistema interrompe il processo di esportazione e notifica l'errore all'utente tramite un apposito messaggio.",
  "Postcondizione": "Il sistema segnala il fallimento dell'operazione e l'esportazione viene annullata."
))

== Requisiti Funzionali

I requisiti funzionali definiscono i comportamenti e le funzionalità che il sistema deve esporre per soddisfare gli scenari descritti nei casi d'uso e le regole di business del dominio.

- *Configurazione e avvio dell'analisi:* Il sistema deve permettere all'utente di configurare una nuova scansione selezionando lo scanner (attualmente vincolato a Qualys), inserendo un singolo indirizzo IP target e definendo l'Asset Context attraverso i tre parametri di ambiente, esposizione e criticità.
- *Monitoraggio in tempo reale:* Il sistema deve fornire un feedback visivo e continuo sullo stato di avanzamento della pipeline di analisi, tracciando le fasi interne (scansione in corso, recupero dati, generazione AI) e intercettando eventuali fallimenti del processo.
- *Orchestrazione della pipeline di backend:* Sebbene invisibile all'utente, il sistema deve gestire in background l'intero ciclo di vita del dato: normalizzazione dei finding grezzi in un modello unificato, arricchimento tramite provider esterni (CVSS, EPSS, KEV), calcolo della priorità operativa tramite il *Priority Engine* e generazione delle spiegazioni in linguaggio naturale tramite AI.
- *Visualizzazione e gestione del report:* Il sistema deve presentare il *Vulnerability Report* finale aggregato. Contestualmente, deve gestire in modo esplicito e comunicare all'utente i casi in cui il report non sia disponibile (analisi in corso, fallita o inesistente).
- *Esportazione documentale controllata:* Il sistema deve permettere all'utente di esportare il dettaglio tecnico delle vulnerabilità in un file formato DOCX. Il processo deve includere la gestione delle eccezioni, notificando all'utente l'eventuale fallimento della compilazione o del download.

== Requisiti Non Funzionali e Vincoli Architetturali

I requisiti non funzionali stabiliscono i vincoli architetturali, i livelli di performance e gli standard di qualità imposti al sistema.

- *Resilienza e *Graceful Degradation*:* La fase di *Explainability* gestita dall'Intelligenza Artificiale è considerata accessoria ai fini della sicurezza. Qualora il provider LLM fallisca o non sia raggiungibile, il sistema deve assorbire l'eccezione e garantire comunque la corretta generazione e visualizzazione del report prioritizzato, omettendo esclusivamente le spiegazioni testuali.
- *Ottimizzazione tramite *Bulk Processing*:* Per garantire basse latenze e limitare il traffico di rete, tutte le interrogazioni verso i provider esterni (NVD, FIRST, CISA KEV e il provider LLM) devono essere eseguite raggruppando i dati in blocchi (operazioni *bulk*), evitando l'iterazione sulle singole vulnerabilità.
- *Paradigma *Backend Source of Truth*:* Per evitare la frammentazione della logica di business, il frontend è declassato a puro livello di presentazione. È fatto divieto di implementare mapper, DTO intermedi o ViewModel nel client; l'interfaccia grafica deve consumare e renderizzare direttamente lo schema JSON API generato dal backend.
- *Design *Scanner-Agnostic*:* Nonostante l'MVP imponga un vincolo funzionale sull'utilizzo esclusivo dello scanner Qualys, l'architettura *Ports & Adapters* del backend deve mantenere il disaccoppiamento della sorgente dati. Questo vincolo assicura l'estendibilità futura verso nuovi scanner senza richiedere modifiche alla pipeline logica centrale.
- *Limiti di responsabilità dell'AI:* Al fine di garantire la tracciabilità delle decisioni (*decision making*), il provider LLM non ha l'autorizzazione di alterare o calcolare il livello di priorità, ma ha il solo compito di argomentare in linguaggio naturale una priorità già determinata deterministicamente dal *Priority Engine*.

== Vincoli Architetturali e Tecnologici

Per limitare la complessità e garantire la manutenibilità (privilegiando un approccio *backend source of truth*), il sistema impone severi vincoli a livello architetturale e implementativo.

- *Architettura Backend:* Il sistema adotta il pattern Ports & Adapters (Hexagonal Architecture) in ambiente Python 3.12, isolando il dominio dalle sorgenti dati e utilizzando Pydantic per i contratti API.
- *Separazione delle responsabilità dell'AI:* L'Intelligenza Artificiale opera esclusivamente come motore di *explainability*. Non può e non deve partecipare in alcun modo al calcolo o alla decisione della priorità operativa (Decision Making).
- *Limiti di responsabilità del Frontend:* Il client web (TypeScript/React) deve fungere da layer di visualizzazione. È fatto esplicito divieto di inserire logiche di dominio, ViewModel aggiuntivi, mapper o DTO intermedi nel frontend. Il client deve consumare direttamente lo schema API JSON esposto dal backend.