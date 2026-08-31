#pagebreak(to:"odd")

#import "../config/glossario-data.typ": gls

= Progettazione Architetturale

L'obiettivo della fase di progettazione è stato delineare la struttura di un sistema in grado di rispettare i requisiti derivati dalla fase di studio del dominio.
La fase iniziale è stata dedicata alla strutturazione del backend, costruendo i diagrammi delle classi per modellare le principali entità del sistema. A questa fase è stata data particolare attenzione poichè è il backend che contiene tutta la logica del sistema, il recupero dati e il motore di classificazione delle vulnerabilità, delegando al frontend solo la parte di interfaccia.
Successivamente è stato strutturato il frontend, ricercando quali fossero i pattern più usati nel framework di Angular per strutturare correttamente un'interfaccia web.

== Architettura di Backend: Ports & Adapters

Il backend è stato modellato con un'architettura esagonale, conosciuta anche come #emph("Ports & Adapters"). Questo tipo di struttura ha come obiettivo primario isolare la logica di business, garantendo un'elevata testabilità e indipendenza da tecnologie esterne. Il #emph([#gls("core")]) in questo modo risulta completamente agnostico rispetto ai dettagli implementativi di framework, database o provider di dati esterni.
Il sistema è strutturato in livelli concentrici:

- #emph("Domain"): rappresenta il nucleo dell'architettura, contiene le entità (modellate tramite classi) sulle quali si basa tutto il sistema ed è privo di dipendenze esterne.

- #emph("Services"): definiscono i casi d'uso dell'applicazione e fungono da orchestratori. Hanno il compito di implementare le #emph("Inbound Ports") per gestire le richieste in ingresso, coordinano gli oggetti del dominio e utilizzano le #emph("Outbound Ports") per delegare all'esterno operazioni come salvataggio o recupero di dati.

- #emph("Ports"): sono il punto di connessione tra il dominio e l'esterno, permettendo una comunicazione strutturata senza creare accoppiamento. Si suddividono in Inbound Ports (definiscono i casi d'uso accessibili dall'esterno) e Outbound Ports (modellano interfacce per dialogare con l'esterno)

- #emph("Adapters"): rappresentano lo strato più esterno e operando come traduttori tra le tecnologie specifiche ed il nucleo. Si suddividono in #emph("Inbound Adapters") (guidano l'input invocando le #emph("Inbound Ports")) e #emph("Outbound Adapters") (vengono guidati dall'applicazione per interagire con l'infrastruttura esterna tramite le #emph("Outbound Ports")).

=== Diagramma delle classi di backend
\
\

#pad(x: -2.5cm)[
  #figure(
    image("/images/AssessmentDiagram.png", width: 100%),
    caption: [Diagramma architetturale dei componenti]
  )
]

=== Servizi Applicativi

==== AssessmentApplicationService

L'`AssessmentApplicationService` è l'orchestratore principale dell'applicazione. Gestisce i tre casi d'uso principali, organizzando tutto il ciclo di vita dell'applicazione.
\ \ 
- `start_assessment(request: AssessmentRequest) -> AssessmentResponse:`
  \ \
  crea l'analisi e chiama in background la pipeline di esecuzione, in questo modo il backend non è bloccato durante l'esecuzione e può gestire altre richieste da parte del frontend. Ritorna al frontend l'id dell'analisi creata, in modo che lo possa usare per chiederne lo stato e recuperarne il report.
\ \
- `get_status(self, analysis_id: str) -> Pipeline:`
  \ \
  utilizza l'id della pipeline per recuperare da una memoria volatile la `StoredAnalysis` contenente l'analisi 

==== PriorityEngine

Il `PriorityEnginer` è una classe di supporto all'`AssessmentApplicationService` che incapsula la logica di calcolo della priorità di ThreatLens.
Questa classe modella il #emph("decision tree") descritto in @VMC

=== Inbound Adapters

L'unico Inbound Adater è l'`AssessmentRouter`, responsabile dell'esposizione delle API di backend al frontend.
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
  In questo modo il frontend può effettuare un polling periodico per monitorare lo stato dell'operazione e mostrare all'utente gli avanzamenti di essa.
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

=== Outbound Adapters

==== Scanner

Per l'MVP è stato codificato un adapter per lo scanner di vulnerabilità #gls("qualys"), ma il sistema grazie alla sua architettura, è aperto a nuovi scanner tramite la codifica di adapter dedicati.
L'adapter deve implementare il metodo della porta:

- `scan(ip: str) -> ScannerResult`\ \
  Tale metodo riceve l'ip del dispositivo target e ritorna l'oggetto di dominio `ScannerResult`, nel quale vengono mappati i risultati provenienti dalle API del tenant di #gls("qualys").

==== AnalysisStore

L'adapter `InMemoryAnalysisStore` gestisce la persistenza volatile delle `StoredAnalysis`, contenenti i risultati di un'analisi prodotti al termine della #gls("pipeline").
Mette a disposizione metodi di lettura e scrittura dell'oggetto:

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

== Principi di Design e Modularità

Durante la progettazione sono state usate una serie di tecniche e design pattern volti a risolvere specifiche sfide implementative. L'applicazione di queste soluzioni ha permesso di strutturare il sistema in modo solido ed efficace, garantendo maggiore modularità e manutenibilità.

=== Inversione delle dipendenze

Il principio di *inversione delle dipendenze* (#emph("Dependency Inversion Principle")) rappresenta il fondamento dell'architettura esagonale perchè rende possibile il disaccoppiamento tra modellazione del dominio e tecnologie esterne.
In ThreatLens il nucleo applicativo, composto dalle classi di dominio e i servizi applicativi, non importa nessuna libreria esterna o tecnologia, ma fa uso solamente di moduli nativi del linguaggio python.
I servizi applicativi, per ottenere i dati necessari al calcolo, non eseguono direttamente chiamate API, ma fanno riferimento a interfacce astratte (le #emph("outbound ports")) che espongono dei metodi generici (per esempio `fetch_data()` o `scan()`)) la cui implementazione sarà gestita da un modulo esterno al #emph("core").
Questo approccio ha tre principali vantaggi:

- *Alta testabilità*: per testare un servizio applicativo non è necessario istanziare l'infrastruttura reale, ma basterà iniettare un componente fittizzio (un #gls[#emph("mock")]).

- *Iisolamento degli errori*: la maggior parte delle criticità in un sistema deriva dall'interazione con tecnolgie esterne (es. timeout di rete, deserializzazione di payload imprevisti o librerie che possono variare e diventare incompatibili con il nostro sistema). Isolandole in un modulo esterno è possibile gestire in modo più efficace e ordinato questi errori, senza inquinare internamente la logica del sistema.

- *Modularità*: se si vuole cambiare tecnologia basta scrivere un altro adapter dedicato, senza dover modificare la logica interna del sistema. Questa flessibilità si è rivelata utile anche in fase di sviluppo, consentendo lo sviluppo del #emph("core") tramite adattatori #emph("dummy") (es. oggetti che ritornano risposte fittizzie simulando le API esterne) per verificare il funzionamento interno del sistema e man mano integrare le tencologie esterne con moduli reali.

=== Estensibilità tramite Strategy e Registry

L'architettura è stata ideata per garantire l'estensibilità verso molteplici strumenti di diagnostica (come #gls("qualys") o #gls("nessus")), in modo da poter confrontare i risultati provenienti da più scanner.
Per risolvere questo problema di design è stato adottato il pattern *Strategy*: ogni adattatore concreto implementa l'interfaccia `ScannerPort`, incapsulando la propria logica di scansione.

La selezione dinamica dello scanner avviene a #emph("run-time"), in base al parametro `ScannerType` fornito nella richiesta dell'utente.
Questa responsabilità è dello `ScannerRegistryAdapter` che concretizza l'interfaccia `ScannerRegistryPort` implementando il pattern #emph("Registry").
A differenza dei pattern creazionali come il #emph("Factory"), che gestiscono l'istanziazione di nuovi oggetti, il #emph("Registry") opera esclusivamente come risolutore di dipendenze.
Lo `ScannerRegistryAdapter` riceve tramite #emph("Dependency Injection") istanze di adattatori già configurate e create all'avvio dell'applicazione dal #emph("Composition Root") (rappresentato nel sistema dal file `dependencies.py` di #gls("fastapi")).

== Modellazione della Pipeline di Assessment

La pipeline di Assessment è il motore del sistema che colleziona dati da una serie di servizi esterni e da questi ne calcola un report finale ordinato.
La classe che orchestra queste operazioni è l'`AssessmentApplicationService` che fa partire l'analisi con il metodo `start_assessment`.
Il processo della pipeline richiede diversi minuti, dunque è stato gestito attraverso l'utilizzo dei #emph("thread") di python.
Nel thread viene avviato in background il metodo `run_pipeline` che consta di cinque fasi:
+ scansione
+ enrichment
+ calcolo della priorità
+ generazione della spiegazione con l'#gls("AI")
+ creazione del report

Nell'implementazione si è cercato di rispettare il single responsability principle, infatti come si può notare dalla struttura della pipeline, nelle classi c'è un metodo principale orchestratore che chiama una serie di metodi privati che eseguono una sola operazione logica. Questo rende il codice più leggibile e manutenibile, cercando di atomizzare le operazioni di una funzione, dando più semantica ed evitando funzioni ingestibili con centinaia di righe di codice, favorendo inoltre testabiità e gestione degli errori.

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

Questa fase è gestita dalla funzione `_calculate_priority` che utilizza una classe 
 



La generazione di un report di vulnerabilità è intrinsecamente un'operazione #emph("time-consuming"), in quanto richiede l'interazione sequenziale con molteplici provider esterni e l'elaborazione di ampi volumi di dati. Per gestire questa complessità, il sistema non si limita a un'esecuzione procedurale sincrona, ma modella il processo attraverso una #emph("pipeline") asincrona orchestrata dal modulo `AssessmentApplicationService`.

=== Esecuzione Asincrona e Macchina a Stati

Per garantire la reattività dell'infrastruttura di backend e non mantenere bloccato il *thread* della richiesta HTTP, il metodo d'ingresso della *pipeline* innesca l'esecuzione su un *thread* demone in #emph("background"), restituendo immediatamente al *client* l'identificativo univoco dell'analisi[cite: 2].

Il ciclo di vita di questo processo in *background* è stato modellato rigorosamente come una macchina a stati. Il dominio definisce il macro-stato dell'operazione (`PipelineState`: in esecuzione, completata o fallita) e il passo atomico attualmente in elaborazione (`PipelineStepType`)[cite: 2]. 
Durante l'esecuzione, il sistema transita sequenzialmente attraverso le seguenti fasi[cite: 2]:
+ *Scanning*: avvio e attesa della scansione delle vulnerabilità sul target.
+ *Enrichment*: arricchimento dei #emph("finding") con metriche di contesto (CVSS, EPSS, KEV).
+ *Priority Calculation*: elaborazione algoritmica della priorità operativa.
+ *AI Explanation*: generazione dell'argomentazione in linguaggio naturale.
+ *Report Generation*: consolidamento dei dati in un documento finale.

L'aggiornamento costante di questi stati su una memoria persistente abilita il pattern architetturale del #emph("polling"): il *frontend* può interrogare deterministicamente il sistema per conoscere lo stato di avanzamento e fornire un #emph("feedback") reattivo all'utente[cite: 2].

=== Single Responsibility Principle nell'Orchestrazione

L'implementazione del flusso rispetta rigorosamente il #emph("Single Responsibility Principle") (SRP)[cite: 2]. Il metodo principale, `_run_pipeline`, non contiene alcuna logica di *business* o di trasformazione dei dati, ma agisce puramente da orchestratore ad alto livello[cite: 2]. 

Esso delega l'effettiva computazione a una serie di metodi privati (come `_scan`, `_enrich_with_data` e `_calculate_priority`), ciascuno dei quali è responsabile unicamente di una singola fase e dell'interazione con la specifica porta di riferimento[cite: 2]. Questa atomizzazione della logica garantisce un'elevata coesione interna e abbatte l'accoppiamento: eventuali modifiche alla logica di arricchimento non intaccano in alcun modo il flusso di calcolo della priorità o le funzioni di *routing*[cite: 2].

=== Resilienza e Fault Tolerance

Uno degli aspetti architetturali più critici della *pipeline* è la sua resilienza ai guasti, differenziata in base alla gravità dell'anomalia rilevata[cite: 2].
Il sistema distingue architetturalmente due tipologie di fallimento:

- *Fallimenti bloccanti (PipelineFailure):* Se un'operazione fondamentale fallisce (ad esempio, lo scanner va in errore o l'algoritmo di prioritizzazione riceve dati corrotti), i singoli metodi sollevano eccezioni specifiche[cite: 2]. L'orchestratore intercetta tali eccezioni e transita immediatamente la macchina a stati in condizione `FAILED`, interrompendo l'esecuzione e salvando i dettagli dell'errore per agevolare il *debugging*[cite: 2].
- *Degradazione morbida (Graceful Degradation):* Fasi dipendenti da API esterne, come il recupero dei punteggi EPSS o la generazione della spiegazione tramite intelligenza artificiale, sono state progettate per essere tolleranti ai guasti infrastrutturali[cite: 2]. Qualora si verifichi un *timeout* di rete (`InfrastructureError`), la *pipeline* non si interrompe[cite: 2]. Il sistema cattura l'eccezione, registra un #emph("Warning") (anomalia non bloccante) associato a quella specifica fase e procede fornendo un report parziale[cite: 2]. Questo approccio garantisce che una momentanea indisponibilità di un *provider* terzo non vanifichi l'intero *assessment*, preservando la disponibilità del servizio[cite: 2].

== Architettura di frontend

=== Diagramma delle classi

==== Service Model
==== Facade
==== ViewModel
==== View


