#pagebreak(to:"odd")

#import "../config/glossario-data.typ": gls

= Tecnologie

== Tecnologie Backend

Per lo sviluppo del backend si è adottato un approccio moderno basato su Python, impiegando framework ad alte prestazioni e librerie fortemente tipizzate. Di seguito sono riportate le tecnologie e dipendenze che compongono l'infrastruttura lato server.

#v(1em)

#table(
  columns: (auto, auto, 1fr),
  align: (col, row) => if col == 1 { center } else { left },
  fill: (col, row) => if row == 0 { rgb("007373") } else { none },
  stroke: 0.5pt + black,
  
  // -- INTESTAZIONE --
  text(fill: white, weight: "bold")[Nome], 
  text(fill: white, weight: "bold")[Versione], 
  text(fill: white, weight: "bold")[Descrizione],

  // -- SEZIONE 1: Linguaggio e Ambiente --
  table.cell(colspan: 3)[*Linguaggio e Containerizzazione*],
  
  [Python], 
  [3.12], 
  [Linguaggio di programmazione utilizzato per il backend, scelto per il suo ampio numero di librerie, la velocità di sviluppo e poichè è il linguaggio di FastAPI, uno dei principali framework di backend.],
  
  [Docker & Compose], 
  [-], 
  [Piattaforma di containerizzazione utilizzata per l'isolamento dell'ambiente di esecuzione e l'orchestrazione dei servizi collegati.],

  // -- SEZIONE 2: Framework e Server Web --
  table.cell(colspan: 3)[*Infrastruttura Web (API & Server)*],
  
  [FastAPI], 
  [0.138.2], 
  [Framework web ad alte prestazioni per la costruzione di API RESTful. Gestisce il routing, il middleware (es. CORS) e la gestione degli errori HTTP.],
  
  [Uvicorn], 
  [0.49.0], 
  [Server web ASGI leggero e veloce, responsabile dell'esecuzione asincrona dell'applicazione FastAPI.],

  // -- SEZIONE 3: Validazione e Dati --
  table.cell(colspan: 3)[*Validazione e Configurazione*],
  
  [Pydantic], 
  [2.13.4], 
  [Libreria per la validazione rigida e type-safe. Viene utilizzato per validare tutti i dati in entrata e in uscita del backend, supportata nativamente da FastAPI.],
  
  [Pydantic Settings], 
  [2.14.2], 
  [Estensione di Pydantic impiegata per la gestione centralizzata e sicura delle configurazioni e delle variabili d'ambiente come le API key.],

  // -- SEZIONE 4: Integrazioni esterne --
  table.cell(colspan: 3)[*Integrazioni e Client HTTP*],
  
  [HTTPX], 
  [0.28.1], 
  [Client HTTP di nuova generazione, impiegato per le chiamate di rete verso i provider esterni.],
  
  [Requests], 
  [-], 
  [Libreria HTTP standard utilizzata in modalità sincrona all'interno degli *adapter* per interrogare gli scanner e le API esterne (es. Qualys, NVD).],
  
  [Google GenAI], 
  [-], 
  [#gls("sdk") ufficiale integrato nell'adapter #gls("AI") per orchestrare le chiamate al modello LLM responsabile della generazione delle spiegazioni.],

  // -- SEZIONE 5: Reportistica --
  table.cell(colspan: 3)[*Generazione Documentale*],
  
  [Python-docx], 
  [1.2.0], 
  [Libreria impiegata per la formattazione del report finale di vulnerabilità in formato #gls("docx").],

  // -- SEZIONE 6: Strumenti di Sviluppo --
  table.cell(colspan: 3)[*Strumenti di Sviluppo (Dev Tools)*],
  
  [Ruff], 
  [0.15.20], 
  [Linter e formatter ad alte prestazioni scritto in Rust, utilizzato per garantire la pulizia e lo standard stilistico del codice sorgente.],
  
  [Pytest], 
  [9.1.1], 
  [Framework per la stesura e l'esecuzione dei test automatici.]
)

== Tecnologie Frontend

In linea con il principio architetturale di mantenere il client come puro strato di visualizzazione (*Backend Source of Truth*), il frontend non contiene logiche di dominio o DTO intermedi, ma si limita a consumare gli schemi API esposti dal server[cite: 7]. Per lo sviluppo della Single Page Application (SPA) è stato impiegato il framework Angular.

#v(1em)

#table(
  columns: (auto, auto, 1fr),
  align: (col, row) => if col == 1 { center } else { left },
  fill: (col, row) => if row == 0 { rgb("007373") } else { none },
  stroke: 0.5pt + black,
  
  // -- INTESTAZIONE --
  text(fill: white, weight: "bold")[Nome], 
  text(fill: white, weight: "bold")[Versione], 
  text(fill: white, weight: "bold")[Descrizione],

  // -- SEZIONE 1: Linguaggi --
  table.cell(colspan: 3)[*Linguaggi di Programmazione e Markup*],
  
  [TypeScript], 
  [~6.0.2], 
  [Superset tipizzato di JavaScript utilizzato per tutto il codice applicativo. Garantisce un *type-checking* rigoroso e permette di mappare specularmente i modelli esposti dalle API JSON del backend[cite: 7].],
  
  [HTML5 & CSS3], 
  [Nativi], 
  [Linguaggi standard utilizzati per la strutturazione semantica della pagina e per il design (styling) dei componenti utente.],

  // -- SEZIONE 2: Framework Principale --
  table.cell(colspan: 3)[*Framework e Moduli Core*],
  
  [\@angular/core], 
  [^22.0.0], 
  [Core del framework Angular. Impiega le moderne primitive di reattività (`signal`, `computed`) e la *Dependency Injection* (`inject`) per una gestione dello stato performante e dichiarativa.],
  
  [\@angular/forms], 
  [^22.0.0], 
  [Modulo impiegato per la costruzione dei form reattivi (`ReactiveFormsModule`). Consente la gestione e la validazione sincrona di campi come l'inserimento dell'IP target e l'Asset Context.],
  
  [\@angular/router], 
  [^22.0.0], 
  [Sistema di routing ufficiale di Angular, utilizzato per la navigazione client-side senza ricaricamento della pagina (`RouterOutlet`, `RouterLink`).],
  
  [\@angular/common/http], 
  [^22.0.0], 
  [Modulo nativo (`provideHttpClient`) impiegato per le chiamate HTTP asincrone verso i servizi RESTful esposti dal backend[cite: 7].],

  // -- SEZIONE 3: Dipendenze Ecosistema --
  table.cell(colspan: 3)[*Dipendenze dell'Ecosistema*],
  
  [RxJS], 
  [~7.8.0], 
  [Libreria per la programmazione reattiva basata su *Observable*, fondamentale per la gestione dei flussi asincroni e degli eventi nel framework Angular.],
  
  [TSLib], 
  [^2.3.0], 
  [Libreria di runtime per TypeScript contenente funzioni helper necessarie per la corretta compilazione del codice applicativo.],
)