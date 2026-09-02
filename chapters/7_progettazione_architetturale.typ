#pagebreak(to:"odd")

#import "../config/glossario-data.typ": gls

= Progettazione Architetturale

L'obiettivo della fase di progettazione è stato delineare la struttura di un sistema in grado di rispettare i requisiti derivati dalla fase di studio del dominio.
La fase iniziale è stata dedicata alla strutturazione del #gls("backend"), costruendo i diagrammi delle classi per modellare le principali entità del sistema. A questa fase è stata data particolare attenzione poichè è il #gls("backend") che contiene tutta la logica del sistema, il recupero dati e il motore di classificazione delle vulnerabilità, delegando al #gls("frontend") solo la parte di interfaccia.
Successivamente è stato strutturato il #gls("frontend"), ricercando quali fossero i pattern più usati nel framework di Angular per strutturare correttamente un'interfaccia web.

== Architettura di #gls("backend"): Ports & Adapters

Il #gls("backend") è stato modellato con un'architettura esagonale, conosciuta anche come #emph("Ports & Adapters"). Questo tipo di struttura ha come obiettivo primario isolare la logica di business, garantendo un'elevata testabilità e indipendenza da tecnologie esterne. Il #emph([#gls("core")]) in questo modo risulta completamente agnostico rispetto ai dettagli implementativi di framework, database o provider di dati esterni.
Il sistema è strutturato in livelli concentrici:

- #emph("Domain"): rappresenta il nucleo dell'architettura, contiene le entità (modellate tramite classi) sulle quali si basa tutto il sistema ed è privo di dipendenze esterne.

- #emph("Services"): definiscono i casi d'uso dell'applicazione e fungono da orchestratori. Hanno il compito di implementare le #emph("Inbound Ports") per gestire le richieste in ingresso, coordinano gli oggetti del dominio e utilizzano le #emph("Outbound Ports") per delegare all'esterno operazioni come salvataggio o recupero di dati.

- #emph("Ports"): sono il punto di connessione tra il dominio e l'esterno, permettendo una comunicazione strutturata senza creare accoppiamento. Si suddividono in Inbound Ports (definiscono i casi d'uso accessibili dall'esterno) e Outbound Ports (modellano interfacce per dialogare con l'esterno)

- #emph("Adapters"): rappresentano lo strato più esterno e operando come traduttori tra le tecnologie specifiche ed il nucleo. Si suddividono in #emph("Inbound Adapters") (guidano l'input invocando le #emph("Inbound Ports")) e #emph("Outbound Adapters") (vengono guidati dall'applicazione per interagire con l'infrastruttura esterna tramite le #emph("Outbound Ports")).

=== Diagramma delle classi di #gls("backend")
\
\

#pad(x: -2.5cm)[
  #figure(
    image("/images/AssessmentDiagram.png", width: 100%),
    caption: [Diagramma architetturale dei componenti]
  )
]

=== Inbound Adapters

L'unico Inbound Adater è l'`AssessmentRouter`, responsabile dell'esposizione delle API di #gls("backend") al #gls("frontend").
Questo modulo delega la validazione dei dati in ingresso e uscita agli schemi pydantic. Questa scelta protegge il core dell'applicazione e lo isola completamente.
I metodi principali di questa classe sono:
\
\
- `start_analysis(
        request: AssessmentRequestSchema,
        use_case: StartAssessmentUseCase,
    ) -> AssessmentResponseSchema:`\ \
  Avvia l'esecuzione della pipeline ricevendo in input l'IP e le informazioni di contesto del dispositivo target.
  Poichè la produzione del report è un'operazione che richiede diversi minuti per completarsi, la funzione non ritorna il report finale, ma lancia il processo in background e ne ritorna l'id.
  In questo modo il #gls("frontend") può effettuare un polling periodico per monitorare lo stato dell'operazione e mostrare all'utente gli avanzamenti di essa.
\
- `get_status(
        analysis_id: str,
        use_case: GetAssessmentStatusUseCase
    ) -> PipelineSchema:`
  \  \
  Dato l'id di un'analisi, ne ritorna lo stato sottoforma di `PipelineSchema` che contiene
  - stato
  - step della pipeline
  - messaggio descrittivo
  - eventuale errore o warnings
\ \ 
- `get_analysis_report(
        analysis_id: str,
        use_case: GetAssessmentReportUseCase
    ) -> VulnerabilityReportSchema:`
  \ \
  Dato l'id di un'analsi ne ritorna, se esistente e pronto, il report finale sottoforma di `VulnerabilityReportSchema`, tra i campi principali contiene una lista di vulnerabilità con le seguenti informazioni:
  - #gls("cve")
  - la severità calcolata dallo scanner (nell'MVP #gls("qualys"))
  - #gls("cvss")
  - #gls("epss")
  - se è presente nel #gls("kev")
  - la severità calcolata tramite il framework di @VMC (#emph("Vulnerability Management Chaining"))
  - un resoconto generato dall'#gls("AI")
\ \
- `export_analysis_report(
        request: ExportRequestSchema,
        analysis_id: str,
        use_case: ExportAssessmentReportUseCase
    ) -> Response:`
  \ \
  Dato l'id di un'analisi e l'estensione richiesta (nell'MVP l'unico formato disponibile è #gls("docx")), ne ritorna il file scaricabile.

=== Servizi Applicativi

==== AssessmentApplicationService

L'`AssessmentApplicationService` è l'orchestratore principale dell'applicazione. Gestisce i tre casi d'uso principali, organizzando tutto il ciclo di vita dell'applicazione.
\ \ 
- `start_assessment(request: AssessmentRequest) -> AssessmentResponse:`
  \ \
  crea l'analisi e chiama in background la pipeline di esecuzione, in questo modo il #gls("backend") non è bloccato durante l'esecuzione e può gestire altre richieste da parte del #gls("frontend"). Ritorna al #gls("frontend") l'id dell'analisi creata, in modo che lo possa usare per chiederne lo stato e recuperarne il report.
\ \
- `get_status(self, analysis_id: str) -> Pipeline:`
  \ \
  utilizza l'id della pipeline per recuperare da una memoria volatile la `StoredAnalysis` contenente l'analisi 

==== PriorityEngine

Il `PriorityEnginer` è una classe di supporto all'`AssessmentApplicationService` che incapsula la logica di calcolo della priorità di ThreatLens.
Questa classe modella il #emph("decision tree") descritto in @VMC. 

=== Outbound Adapters

==== Scanner

Per l'MVP è stato codificato un adapter per lo scanner di vulnerabilità #gls("qualys"), ma il sistema grazie alla sua architettura, è aperto a nuovi scanner tramite la codifica di adapter dedicati.
L'adapter deve implementare il metodo della porta:

- `scan(ip: str) -> ScannerResult`\ \
  Tale metodo riceve l'ip del dispositivo target e ritorna l'oggetto di dominio `ScannerResult`, nel quale vengono mappati i risultati provenienti dalle API del tenant di #gls("qualys").

==== AnalysisStore

L'adapter `InMemoryAnalysisStore` gestisce la persistenza volatile delle `StoredAnalysis`, contenenti i risultati di un'analisi prodotti al termine della #gls("pipeline").
Mette a disposizione metodi di lettura e scrittura dell'oggetto:
\ \
- `get_analysis(analysis_id: str) -> StoredAnalysis`: \
  ritorna l'oggetto desiderato tramite il suo id\ \

- `get_all_analysis() -> list:` \
  ritorna tutte le analisi salvate nel sistema\ \ 

- `save_analysis(analysis: StoredAnalysis) -> None:`\
  salva un'analisi nel sistema\ \

==== Data providers

Il recupero dei dati necessari al calcolo della gravità (#gls("cvss"), #gls("epss"), #gls("kev")), viene gestito da tre classi che si occupano di usare API di servizi esterni e normalizzare la loro risposta in oggetti di dominio.

- `NvdCvssAdapter` presenta il metodo `get_cvss_bulk(cve_list: list[str]) -> dict[str, CvssData]` che ritorna dal #emph("database") di #gls("nvd") i valori #gls("cvss") delle #gls("cve") che gli sono state fornite.\ \

- `FirstEpssAdapter` espone il metodo `get_epss_bulk(cve_list: list[str]) -> dict[str, EpssData]` che ritorna dal database #emph("database") del #gls("first") i valori #gls("epss").\ \

- `CisaKevAdapter` ha il metodo ` check_kev_bulk(cve_list: list[str]) -> dict[str, KevData]` che indica per ogni #gls("cve") se sia presente nel catalogo del #gls("cisa").\ \

==== AiAdapter

Il `GeminiExplanationAdapter` adapter contretizza l'interfaccia definita in `AiExplanationPort`. Il modulo implementa il metodo:
\ \
  `generate_explanation_bulk(
        vulnerabilities: list[PrioritizedVulnerability],
    ) -> ExplanationById`
\ \
Questo metodo riceve in input l'output delle fasi precedenti della #gls("pipeline"): una lista di vulnerabilità già prioritizzate e arricchite con le relative metriche di contesto. Restituisce una struttura dati indicizzata (`ExplanationById`) che mappa l'identificativo di ciascuna vulnerabilità al resoconto testuale generato dall'Intelligenza Artificiale.

== Principi di Design e Modularità nel #gls("backend")

Durante la progettazione sono state usate una serie di tecniche e design pattern volti a risolvere specifiche sfide implementative. L'applicazione di queste soluzioni ha permesso di strutturare il sistema in modo solido ed efficace, garantendo maggiore modularità e manutenibilità.

=== Inversione delle dipendenze

Il principio di *inversione delle dipendenze* (#emph("Dependency Inversion Principle")) rappresenta il fondamento dell'architettura esagonale perchè rende possibile il disaccoppiamento tra modellazione del dominio e tecnologie esterne.
In ThreatLens il nucleo applicativo, composto dalle classi di dominio e i servizi applicativi, non importa nessuna libreria esterna o tecnologia, ma fa uso solamente di moduli nativi del linguaggio python.
I servizi applicativi, per ottenere i dati necessari al calcolo, non eseguono direttamente chiamate #gls("api"), ma fanno riferimento a interfacce astratte (le #emph("outbound ports")) che espongono dei metodi generici (per esempio `fetch_data()` o `scan()`)) la cui implementazione sarà gestita da un modulo esterno al #emph("core").
Questo approccio ha tre principali vantaggi:

- *Alta testabilità*: per testare un servizio applicativo non è necessario istanziare l'infrastruttura reale, ma basterà iniettare un componente fittizzio (un #emph[#gls("mock")]).

- *Iisolamento degli errori*: la maggior parte delle criticità in un sistema deriva dall'interazione con tecnolgie esterne (es. #emph("timeout") di rete, deserializzazione di #emph[#gls("payload")] imprevisti o librerie che possono variare e diventare incompatibili con il nostro sistema). Isolandole in un modulo esterno è possibile gestire in modo più efficace e ordinato questi errori, senza inquinare internamente la logica del sistema.

- *Modularità*: se si vuole cambiare tecnologia basta scrivere un altro adapter dedicato, senza dover modificare la logica interna del sistema. Questa flessibilità si è rivelata utile anche in fase di sviluppo, consentendo lo sviluppo del #emph("core") tramite adattatori #emph("dummy") (es. oggetti che ritornano risposte fittizzie simulando le #gls("api") esterne) per verificare il funzionamento interno del sistema e man mano integrare le tencologie esterne con moduli reali.

=== Estensibilità tramite Strategy e Registry

L'architettura è stata ideata per garantire l'estensibilità verso molteplici strumenti di diagnostica (come #gls("qualys") o #gls("nessus")), in modo da poter confrontare i risultati provenienti da più scanner.
Per risolvere questo problema di design è stato adottato il pattern *Strategy*: ogni adattatore concreto implementa l'interfaccia `ScannerPort`, incapsulando la propria logica di scansione.

La selezione dinamica dello scanner avviene a #emph("run-time"), in base al parametro `ScannerType` fornito nella richiesta dell'utente.
Questa responsabilità è dello `ScannerRegistryAdapter` che concretizza l'interfaccia `ScannerRegistryPort` implementando il pattern #emph("Registry").
A differenza dei pattern creazionali come il #emph("Factory"), che gestiscono l'istanziazione di nuovi oggetti, il #emph("Registry") opera esclusivamente come risolutore di dipendenze.
Lo `ScannerRegistryAdapter` riceve tramite #emph("Dependency Injection") istanze di adattatori già configurate e create all'avvio dell'applicazione dal #emph("Composition Root") (rappresentato nel sistema dal file `dependencies.py` di #gls("fastapi")).

== Modellazione della #gls("pipeline") di assessment

La #gls("pipeline") di assessment è il motore del sistema che colleziona dati da una serie di servizi esterni e da questi ne calcola un report finale ordinato.
La classe che orchestra queste operazioni è l'`AssessmentApplicationService` che fa partire l'analisi con il metodo `start_assessment`.
Il processo della #gls("pipeline") richiede diversi minuti, dunque è stato gestito attraverso l'utilizzo dei #emph("thread") di Python.
Nel thread viene avviato in background il metodo `run_pipeline` che consta di cinque fasi:
+ scansione
+ enrichment
+ calcolo della priorità
+ generazione della spiegazione con l'#gls("AI")
+ creazione del report

Nell'implementazione si è cercato di rispettare il single responsability principle, infatti come si può notare dalla struttura della #gls("pipeline"), nelle classi c'è un metodo principale orchestratore che chiama una serie di metodi privati che eseguono una sola operazione logica. Questo rende il codice più leggibile e manutenibile, cercando di atomizzare le operazioni di una funzione, dando più semantica ed evitando funzioni ingestibili con centinaia di righe di codice, favorendo inoltre testabiità e gestione degli errori.

=== Fase 1: Scansione

Viene gestita dalla funzione `_scan` che utilizza la `ScannerRegistryPort` per recuperare lo scanner selezionato e la `ScannerPort` per ottenere un oggetto `ScannerResult`, contenente la lista di #emph("finding") trovati.

=== Fase 2: Enrichment

La logica di questa fase risiede nella funzione `_enrich_with_data` che preleva la lista di #gls("cve") dall'oggetto `ScannerResult` creato nella fase precedente.
In sequenza viene data questa lista di vulnerabilità ai tre data provider:
- `_cvss_provider`
- `_epss_provider`
- `_kev_provider`
che con i loro metodi `_get_*_bulk` (ogni provider al posto di `*` ha il dato che ricerca) arricchiscono la cve con i dati per il calcolo.
Ne risulta una lista di `EnrichedVulnerability` che contiene degli elementi indicizzati per cve con i dati che ne indicano la gravità.

=== Fase 3: Calcolo della priorità

Questa fase è affidata al metodo `_calculate_priority`. La computazione è delegata al componente `PriorityEngine`, che incapsula la logica del #emph[#gls("decision-tree")] descritta in @VMC.

L'elaborazione restituisce una lista di `PrioritizedVulnerability`. Ad ogni vulnerabilità viene assegnata una `OperationalPriority` che ne categorizza la gravità in ordine crescente:
- `TRACK`
- `TRACK*`
- `ATTEND`
- `ACT`

==== Fase 4: Generazione della spiegazione con l'#gls("AI")

Dopo aver ottenuto tutti i dati necessari all'analisi di una #gls("cve"), l'#gls("AI") ha il compito di produrre una spiegazione sintetica in linguaggio naturale, con l'obiettivo di fornire un chiaro contesto della situazione motivando la priorità operativa assegnata dal `PriorityEngine`. La logica di questa fase risiede nel metodo `_generate_ai_explanation` che ha la responsabilità di utilizzare il metodo dell'`AiExplanationPort`, gestendone correttamente la risposta.
Per una questione di performance, nell'#gls("mvp") vengono analizzate solamente le prime cinque vulnerabilità più gravi.
Queste vengono date all'`_ai_explanation_provider` che tramite il metodo `generate_explanation_bulk` genera le spiegazioni necessarie a costruire la lista di `ExplainedVulnerability`.

==== Fase 5: Creazione del report

Come ultima fase vi è la creazione di un report riassuntivo. Il metodo `_generate_report` ha il compito di aggiornare lo stato della #gls("pipeline") a `COMPLETED` e salvare in memoria l'oggetto finale, il `VulnerabilityReport`, con un identificativo grazie al quale sarà possibile recuperarlo e mostrarlo all'utente.

=== Architettura di gestione degli errori

Al fine di tradurre in modo granulare eccezioni provenienti dall'esterno, facendole fluire nel modo corretto fino all'interfaccia utente, il sistema implementa un'architettura di gestione degli errori strutturata e centralizzata.
Questo non solo permette di averne una gestione ordinata, ma anche di isolare nei punti corretti la logica di gestione delle eccezioni, in modo da non inquinare il dominio con la logica riguardante le tecnologie esterne.
La logica di strutturazione è stata individuare le possibili classi di errore del sistema e costruirci una gerarchia di errori che potesse incapsulare anche i diversi tipi di errore provenienti da servizi esterni.

In principio l'architettura suddivide le eccezioni nelle seguenti categorie principali:
- *Eccezioni Applicative (`ApplicationError`)*
- *Fallimenti di #gls("pipeline") (`PipelineError`)*
- *Guasti Infrastrutturali (`InfrastructureError`)*

==== Eccezioni Applicative

Rappresentano condizioni previste da casi d'uso del sistama. Ognuna è associata a un codice di errore standardizzato (`ErrorCode`).
Le eccezioni applicative del sistema implementano la generica `ApplicationError` (che a sua volta implementa la classe `Exception`) e sono:

- `AnalysisNotFoundError`: segnala che l'analisi ricercata non è stata trovata
- `ReportNotReadyError`: segnala che il report non è ancora stato generato
- `UnsupportedScannerError`: segnala che la richiesta di scanner non è supportata dal sistema
- `UnsupportedExportedExtensionError`: segnala che l'estensione richiesta non è supportata dal sistema
- `ExportError`: segnala un errore durante l'esportazione

==== Fallimenti di #gls("pipeline")

Rappresentano errori bloccanti che si verificano durante il flusso sequenziale della #gls("pipeline"). Queste eccezioni hanno un codice di errore che registra lo specifico step di esecuzione in cui il sistema si è arrestato, permettendo di identificare con precisione il punto di rottura.
I fallimenti della pipeline implementano la generica `PipelineFailure` (che a sua volta implementa la classe `Exception`) e sono:

- `ScanFailure`: segnala un errore duranta la fase di scansione.
- `PriorityCalculationFalure`: segnala un errore durante la fase di calcolo interno della priorità.
- `ReportBuildFailure`: segnala un errore durante la fase di costruzione del report.
- `UnexpectedPipelineFailure`: errore generico per errori non contemplati nel corso della #gls("pipeline").

==== Guasti infrastrutturali

Modellano i fallimenti derivati dagli outbound adapters. Queste classi hanno il compito di tradurre le eccezioni sollevate dalle librerie di terze parti o dalle #gls("api") esterne in errori gestibili dal sistema. Solitamente API e librerie esterne possono ritornare una vasta gamma di errori differneti, per questo sono stati gestiti i casi di errore principali o che sono stati ritenuti rilevanti avendone fatta esperienza in fase di sviluppo. Questi errori vengono incapsulati nelle classi di errori di sistema più ampie con annessa una descrizione esplicativa. L'impatto applicativo di questi errori è delegato ai livelli superiori del sistema.
I guasti infrastrutturali implementano il generico `InfrastructureError` (che a sua volta implementa la classe `Exception`) e sono:

- `ProviderUnavailableError`: il provider non è raggiungibile o non risponde.
- `ProviderTimeoutError`: il provider non ha risposto entro il timeout.
- `ProviderAuthenticationError`: il provider ha rifiutato le credenziali. 
- `ProviderRateLimitError`: il provider ha applicato un limite alle richieste.
- `ProviderResponseError`: la risposta ricevuta non rispetta il formato atteso.
- `PersistenceError`: errore durante lettura o scrittura della persistenza.
- `FileGenerationError`: errore tecnico durante la generazione di un file.

==== Traduzione verso l'interfaccia

La responsabilità di tradurre le eccezioni interne in risposte #gls("http") è delegata ad appositi #emph("exception handlers"). Questo approccio garantisce:

- *Standardizzazione del contratto #gls("api"):* ogni errore esposto all'utente segue un `ErrorResponseSchema` che include:
  - un codice identificativo
  - un messaggio descrittivo
  - dettagli tecnici opzionali

- *Mappatura semantica dei codici:* gli errori applicativi vengono tradotti nei corretti codici #gls("http"), come `404 Not Found` per risorsa inesistente o `409 Conflict` per conflitti di stato applicativo.

- *Gestione della validazione:* gli errori generati da input non conformi vengono restituiti con codice `422 Unprocessable Content`

- *Tracciamento e sicurezza:* eccezioni inattese non vengono esposte in chiaro all'utente, ma il sistema restituisce un errore interno generico (`500 Internal Server Error`), registra la traccia dell'eccezione (#emph("stack trace")) tramite i log. Questo facilita le operazioni di debug senza compromettere la sicurezza del sistema.

== Architettura di #gls("frontend")

Il #gls("frontend") è stato progettato adottando un'architettura a livelli (#emph[Layered Architecture]) al fine di favorire una rigorosa separazione delle responsabilità. Sebbene nella pratica comune di sviluppo dell'ecosistema Angular si faccia talvolta riferimento al pattern #emph("Model-View-ViewModel") (MVVM), a livello architetturale la struttura implementata si fonda sull'integrazione del pattern #emph[Presentation Model] con un livello di astrazione basato su #emph[Facade].
Questa struttura è stata adottata dopo un'attenta analisi delle moderne #emph("best practice") consolidate all'interno della #emph("community") di sviluppatori Angular. Tali pattern ampiamente discussi e validati nei canali specializzati di settore, rappresentano oggi uno standard emergente per la scalabilità e manutenibilità di applicazioni web reattive.
\ 
Questa scomposizione garantisce che l'interfaccia utente sia completamente disaccoppiata dalle complessità di rete, dalla logica di dominio e dall'orchestrazione dei flussi asincroni. Il sistema è pertanto strutturato in tre macro-livelli:
- *Presentation Layer:* Organizzato secondo il pattern #emph[Smart e Dumb components], in cui i componenti presentazionali (View) gestiscono esclusivamente il rendering, mentre i componenti contenitore (Smart) adattano lo stato alle esigenze della vista.
- *Abstraction Layer:* Mediato da un'implementazione reattiva del pattern Facade, che non si limita a fornire un'interfaccia unificata, ma orchestra i flussi asincroni e funge da singola fonte di verità per lo stato della UI.
- *Core Layer:* Composto da servizi API rigorosamente #emph[stateless] che operano come #emph[Gateway] verso il backend, rispettando il principio di singola responsabilità.

=== Diagramma delle classi

=== Service Model

Hanno la responsabilità di comunicare con le #gls("api") di #gls("backend"), tramite chiamate #gls("http"). Secondo i principi della programmazione reattiva, i metodi di queste classi non ritornano un oggetto statico, ma un canale dinamico dal quale è possibile "osservare" i dati richiesti.
I moduli che hanno questo compito sono:

==== AnalysisApi

Si occupa della gesitone di un'analisi di #gls("vulnerability-assessment"), presenta i metodi:

- `startAnalysis(AssessmentRequest): Observable<AssessmentResponse>`: \ metodo che lancia la creazione dell'analisi e riceve un #emph("Observable") di tipo `AssessmentResponse` contenente l'identificativo del processo lanciato.
\ \ 
- `getAnalysesSummary(): Observable<AnalysesSummary>`: \ metodo che ritorna id e stato di tutte le analisi salvate nella memoria del sistema, serve a visualizzare nella home la lista di analisi create.

==== CapabilitiesApi

Si occupa di recuperare le funzionalità che il sistema dispone, serve a recuperare le opzioni selezionabili nel modulo di configurazione dell'analisi (come scanner disponibili e opzioni di contesto dell'asset). Questa classe è particolarmente utile perchè rende il backend intelligente e dipendente dalle funzionalità codificate nel #gls("backend"): nel caso si aggiunga un nuovo scanner non sarà necessario modificare il #gls("frontend"), essendo lui stesso a rilevare un nuovo scanner e mostrandone automaticamente l'opzione disponibile. Questo modulo è un buon esempio di come nel sistema siano le tecnologie esterne a dipendere da logica e configurazioni interne.
Il metodo di questa classe è:
\ \
- `getCapabilities(): Observable<SystemCapabilities>`: \
  ritorna le funzionalità che il sistema dispone all'utente

==== PipelineApi

Servizio che si occupa di richiedere lo stato della #gls("pipeline") di un'analisi, con il metodo:
\ \
- `getStatus(analysisId): Observable<Pipeline>`:\  ritorna un #emph("Observable") di tipo `Pipeline` (un oggetto di #gls("frontend")) contenente le informazioni della #gls("pipeline") che verranno mostrate all'utente. 

==== ReportApi

Ha la responsabilità di gestire operazioni riguardanti il report: richiederlo per mostrarlo all'utente e richiederne l'esportazione.
\ \ 
- `getReport(analysisId): Observable<VulnerabilityReport>`: \
  ritorna un #emph("Observable") di tipo `VulnerabilityReport`, contenente tutte le informazioni da mostrare all'utente.

=== Facade

Questo layer ha la responsabilità di sollevare lo #emph("Smart Component") complessa gestione dei flussi di dati reattivi basata sugli #emph("Observable"). Questi canali di comunicazione asincrona richiedono un'orchestrazione attenta e centralizzata.
Mischiare tale logica con la gestione dei #emph("Dumb Component"), avrebbe generato una classe difficilmente manutenibile.
Delegando la gestione degli #emph("Observable") alla #emph("Facade"), si rispetta il #emph("Single Responsability Principle"), mantenendo il livello di presentazione pulito e focalizzato sulle logiche dell'interfaccia.

==== HomeFacade

Questo modulo si occupa di gestire lo stato della #emph("Home"), la pagina principale di ThreatLens.
Presenta un singolo metodo:
\ \
- `loadAnalyses(): void`:\
  utilizza `analysisApi` per caricare le analisi nella home, gestendone il loro stato ed eventuali errori.

==== NewAnalysisFacade

Questa classe ha il compito di gestire lo stato della pagina di analisi, inclusa la pipeline visiva, presenta due metodi:
\ \
- `loadCapabilities(): void`:\
  utilizza `capabilitiesApi` per caricale le funzionalità del sistema, gestendone stato ed eventuali errori.
\ \
- `startAnalysis(AssessmentRequest): void`:\
  utilizza `analysisApi` per lanciare l'analisi, resta in ascolto sul canale di risposta attendendo l'identificativo del processo generato.
  Si occupa anche di far partire il metodo privato `startPollingStatus(analysisId)` che chiede periodicamente lo stato del processo, in modo da monitorare l'andamento della #gls("pipeline") di #gls("backend"), informando l'utente del suo stato e ridirezionando l'interfaccia alla pagina di report una volta terminata l'esecuzione.

==== ReportFacade

Il `ReportFacade` orchestra lo stato della pagina di report, con i metodi:
\ \
- `loadReport(analysisId): void`:\
  utilizza `reportApi` per recuperare il report e gestire il flusso di dati ed eventuali errori.
\ \
- `exportReport(analysisId, format): void`:\
  utilizza `reportApi` per generare e recuperare il file esportabile nel formato selezionato dall'utente.

=== Smart Component (ViewModel)

Questo componente agisce come contenitore e orchestratore a livello di interfaccia, fungendo da #emph[Presentation Model]. Lo #emph[Smart Component] non implementa logica di business o chiamate di rete dirette; si limita a passare i dati elaborati ai componenti figli e ad ascoltare i loro eventi, delegando le azioni dell'utente ai livelli architetturali sottostanti.

=== Dumb Component (View)

Rappresentano il livello di presentazione puro. La loro unica responsabilità è presentare gli elementi dell'interfaccia utente (UI) e delegare l'interazione dell'utente "verso l'alto", notificando lo #emph[Smart Component] tramite l'emissione di eventi. Essendo completamente privi di logica applicativa e ignari dei servizi #gls("api") o della Facade, questi componenti lavorano esclusivamente sui dati ricevuti in ingresso, risultando pertanto altamente riutilizzabili.

=== Observer Pattern

=== Il Pattern Observer e la Gestione Reattiva

Nell'ambito dello sviluppo di interfacce web moderne, la gestione degli eventi asincroni, delle chiamate di rete e dei flussi di dati continui rappresenta una sfida architetturale di primaria importanza. Per orchestrare tale complessità in modo efficiente, l'infrastruttura di Angular adotta sistematicamente il pattern comportamentale #emph[Observer].

Nella sua definizione canonica, l'Observer pattern stabilisce una dipendenza uno-a-molti tra oggetti: quando l'oggetto principale (denominato #emph[Subject] o #emph[Publisher]) subisce un cambiamento di stato, tutti gli oggetti da esso dipendenti (#emph[Observer] o #emph[Subscriber]) vengono notificati e aggiornati in modo automatico. All'interno dell'ecosistema Angular, questa dinamica è implementata in modo nativo e potenziata attraverso la libreria #emph[RxJS] (Reactive Extensions for JavaScript), la quale modella i flussi di dati nel tempo tramite il costrutto degli #emph[Observable].

All'interno dell'architettura della piattaforma, l'Observer pattern costituisce il motore fondamentale per la comunicazione tra i livelli di astrazione e di presentazione, ribaltando il paradigma di controllo da un approccio imperativo (#emph[pull]) a uno puramente reattivo (#emph[push]):

- *Il ruolo del Publisher (Facade):* Il livello di astrazione, oltre a mascherare le chiamate API, detiene lo stato applicativo locale (frequentemente tramite l'utilizzo di classi specializzate come i `BehaviorSubject`). La Facade espone questo stato all'esterno esclusivamente sotto forma di flussi continui in sola lettura (`Observable`).
- *Il ruolo del Subscriber (Smart Component):* Il #emph[ViewModel] agisce da osservatore. Invece di interrogare ripetutamente i servizi per verificare la presenza di nuovi dati, lo #emph[Smart Component] si iscrive (#emph[subscribe]) ai flussi esposti dalla Facade. Non appena un nuovo dato è disponibile — ad esempio l'aggiornamento della percentuale di completamento della scansione o la ricezione del report finale — il componente riceve istantaneamente la notifica e propaga il nuovo stato ai #emph[Dumb Component] per il rendering.

L'adozione rigorosa di questo pattern garantisce un disaccoppiamento totale tra la logica di recupero e orchestrazione dei dati e la loro effettiva visualizzazione. Inoltre, permette di gestire in modo elegante e dichiarativo scenari asincroni complessi, come il #emph[polling] periodico verso il backend, assicurando un'interfaccia utente (#gls("UI")) fluida e costantemente allineata con lo stato del sistema.





