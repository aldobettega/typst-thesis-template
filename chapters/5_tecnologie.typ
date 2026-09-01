#pagebreak(to:"odd")

#import "../config/glossario-data.typ": gls

= Tecnologie

== Tecnologie Backend

Per lo sviluppo del #gls("backend") si è adottato un approccio moderno basato su Python. Di seguito sono riportate le tecnologie e dipendenze che compongono l'infrastruttura lato server.

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
  [Linguaggio di programmazione utilizzato per il #gls("backend"), scelto per il suo ampio numero di librerie, la velocità di sviluppo e poichè è il linguaggio di FastAPI, uno dei principali framework di #gls("backend").],
  
  [Docker & Docker Compose], 
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
  [Libreria per la validazione rigida e type-safe. Viene utilizzato per validare tutti i dati in entrata e in uscita del #gls("backend"), supportata nativamente da FastAPI.],
  
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

Per lo sviluppo del frontend è stato scelto il framework Angular 22, per il suo vasto ecosistema di programmazione web (che include il routing nativo), una forte scalabilità per la sua architettura a componenti, per la presenza di pattern integrati nel sistema come l'iniezione delle dipendenze, e per l'uso di moderne liberie come RxJS per la programmazione reattiva.

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
  [Linguaggio utilizzato per il frontend che garantirearantisce un *type-checking* rigoroso, nativo del framework di Angular.],
  
  [HTML5 & CSS3], 
  [Nativi], 
  [Linguaggi standard utilizzati per la strutturazione semantica della pagina e per il design dei componenti utente.],

  // -- SEZIONE 2: Framework Principale --
  table.cell(colspan: 3)[*Framework e Moduli Core*],
  
  [Angular], 
  [^22.0.0], 
  [Framework open source per lo sviluppo di Single-page application, è stato usato per realizzare il frontend dell'applicazione.],
  
  [RxJS], 
  [~7.8.0], 
  [Libreria per la programmazione reattiva basata su *Observable*, fondamentale per la gestione dei flussi asincroni e degli eventi nel framework Angular.],
)

== Strumenti di Sviluppo e Ambiente

Durante il ciclo di vita del software sono stati inoltre usati una serie di strumenti trasversali che hanno garantito un corretto sviluppo della piattaforma.

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

  // -- SEZIONE 1: Codifica e Versionamento --
  table.cell(colspan: 3)[*Codifica e Versionamento*],
  
  [Visual Studio Code], 
  [-], 
  [Editor di codice sorgente avanzato utilizzato come ambiente di sviluppo integrato (IDE) principale, configurato con estensioni per il supporto nativo a Python, TypeScript e Typst.],
  
  [Git], 
  [-], 
  [Sistema di controllo di versione distribuito, impiegato per il tracciamento progressivo delle modifiche, la gestione dei #emph("branch") e la storicizzazione sicura del progetto.],

  // -- SEZIONE 2: Containerizzazione e Virtualizzazione --
  table.cell(colspan: 3)[*Ambiente di Esecuzione e Test*],
  
  [VMware], 
  [-], 
  [Software #emph("hypervisor") utilizzato per l'esecuzione locale di macchine virtuali isolate. È risultato fondamentale per istanziare i target di test da analizzare tramite lo scanner.],

  [Qualys Virtual Scanner], 
  [-], 
  [Appliance virtuale fornita da Qualys, eseguita in locale per materializzare le scansioni sui target interni comunicando con l'infrastruttura Cloud.],

  [Metasploitable 2], 
  [-], 
  [Macchina virtuale basata su Linux, intenzionalmente vulnerabile. È stata impiegata come ambiente #emph("target") controllato per validare l'effettivo rilevamento delle minacce.],

  // -- SEZIONE 3: Servizi Esterni e API --
  table.cell(colspan: 3)[*Servizi Esterni e API*],

  [Qualys Tenant API], 
  [-], 
  [Interfaccia REST esposta dal Cloud Qualys per orchestrare il processo di scansione, inviare comandi all'appliance locale ed estrarre i referti tecnici.],
  
  [Google AI API], 
  [-], 
  [Servizio di intelligenza artificiale interrogato per generare la spiegazione contestuale delle vulnerabilità rilevate, sfruttando avanzati modelli linguistici.],

  [NVD API], 
  [-], 
  [API del National Vulnerability Database interrogata per recuperare le metriche base e il punteggio di severità (#gls("cvss")) associato alle singole vulnerabilità.],

  [CISA KEV Catalog], 
  [-], 
  [Catalogo fornito dalla CISA e interrogato tramite feed JSON per verificare in modo deterministico se una specifica vulnerabilità risulta attivamente sfruttata (#emph("Exploited")).],

  [FIRST EPSS API], 
  [-], 
  [Endpoint REST fornito dal framework FIRST per il recupero dell'#gls("epss"), utilizzato per stimare la probabilità di sfruttamento di una falla entro 30 giorni.],

  // -- SEZIONE 4: Progettazione e Documentazione --
  table.cell(colspan: 3)[*Progettazione, Appunti e Documentazione*],
  
  [PlantUML], 
  [-], 
  [Strumento utilizzato per la modellazione e la generazione automatica di diagrammi architetturali.],
  
  [Notion], 
  [-], 
  [Piattaforma di produttività impiegata come #emph("knowledge base") centralizzata per la raccolta degli appunti, la stesura dei requisiti e il tracciamento delle decisioni progettuali.],

  [MkDocs], 
  [-], 
  [Generatore di siti web statici tipicamente usato per documentare il codice di progetti Python tramite file in formato Markdown.]
)