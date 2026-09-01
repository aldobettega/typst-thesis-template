#import "../config/glossario-data.typ": gls

#pagebreak(to:"odd")

= Processi e metodologie

In questo capitolo viene riportato il modo in cui mi sono interfacciato con i tutor aziendali e come abbiamo organizzato il lavoro fissando i vari obiettivi lungo il corso del progetto.

== Metodologia di lavoro

Durante le prime settimane l'attività si è svolta in modalità ibrida, per poi passare ad un regime completamente da remoto a causa dell'inagibilità della sede aziendale. Sebbene la modalità a distanza sia stata preponderante, l'efficienza operativa e la collaborazione non ne hanno risentito. L'uso di canali di comunicazione sincroni e asincroni come #gls("teams") hanno garantito un aggiornamento continuo sull'avanzamento delle attività e un supporto immediato in caso di difficoltà.

Quotidianamente era prevista una breve riunione di allineamento per monitorare i progressi e affrontare le eventuali problematiche emerse. Infine, ogni venerdì mattina si teneva una sessione di revisione più formale, dedicata alla presentazione dei risultati settimanali, all'analisi della direzione del progetto e alla discussione di eventuali proposte o azioni correttive.

== Pianificazione delle attività

L'organizzazione delle attività è stata calcolata in divenire, in modo da allocare correttamente le risorse disponibili ed avere sotto controllo il raggiungimento degli obiettivi, restando entro il tempo prestabilito dal tirocinio.
In autonomia è stato stilato un calendario settimanale su #gls("notion"), dove veniva tenuta traccia degli obiettivi giornalieri. 
Questo strumento ha permesso di monitorare efficacemente lo stato di avanzamento, offrendo la flessibilità di riprogrammare i task rivelatisi più complessi o di anticipare le attività successive in caso di completamento anticipato del carico giornaliero.

Questo crono-programma veniva poi condiviso a fine settimana per mostrare il progresso raggiunto e condividere le attività che erano state più onerose, al fine di chiedere un consiglio ai colleghi più esperti per le problematiche ancora aperte.

=== Prima settimana

L'attività di tirocinio si è aperta con una fase di inserimento in azienda, focalizzata sull'acquisizione del metodo di lavoro e sulla strutturazione delle attività di sviluppo del progetto.
In seguito è stato fatto uno studio approfondito delle principali tecnologie con le quali si sarebbe sviluppata la piattaforma, partendo dal framework di #gls("angular") e il suo linguaggio #gls("typescript").
Lo studio teorico dei concetti è stato affiancato da esercizi, tutorial e progetti didattici orientati alla comprensione dei moduli principali del framework.

=== Seconda settimana

Durante la seconda settimana è continuato lo studio di #gls("angular"), vedendo concetti più avanzati come il #emph("routing"), gli #emph("observer"), la #emph("dependency injecion").
In seguito è stato affrontato il dominio del problema: sono stati studiati i concetti di #gls("cve") e #gls("cpe") e che cosa sia uno scanner di vulnerabilità. Questo studio è stato integrato dalla lettura di articoli scientifici inerenti alle tematiche del #gls("vulnerability-assessment") e della prioritizzazione del rischio.


=== Terza settimana

In questo periodo è stato completato lo studio del dominio della piattaforma ed è inizata l'analisi dei requisiti della piattaforma, delineando le principali funzionalità dell'applicazione e la sua interfaccia.
Contestualmente è stata fatta formazione riguardo alla piattaforma di #gls("qualys"), prodotto enterprise utilizzato dall'azienda per scansionare le vulnerabilità di dispositivi.
È stata poi fatta della formazione sull'utilizzo di docker e docker compose, raffinando i concetti già presenti per avere un più consapevole utilizzo dello strumento.

=== Quarta settimana

Durante la quarta settimana è iniziata la progettazione del sistema, definendo le classi di #gls("backend") e le componenti #gls("angular") con le loro principali funzioni. Per formalizzare ed esporre i risultati del lavoro sono stato prodotti dei diagrammi in #gls("uml"), per discutere della direzione progettuale e raffinare il lavoro compiuto.
In aggiunta è stata progettata l'organizzazione della repo e dei suoi file, in modo da poter procedere con uno sviluppo il quanto più possibile ordinato ed efficiente.
È continuato lo studio delle tecnologie al fine di comprendere i pattern di organizzazione del codice di #gls("angular") e #gls("fastapi"), in modo da utilizzarle nello sviluppo della piattaforma rispettando la progettazione architetturale.

=== Quinta settimana

In questo periodo è iniziata la codifica del prodotto, partendo dalle funzionalità di #gls("backend").
Si è sviluppato in modo progressivo integrando man mano le parti che contribuissero al sistema di calcolo delle priorità, questa modularità ha facilitato la scrittura dei test e ha consentito di produrre risultati parziali ma concreti durante tutto il ciclo di implementazione.
In particolare sono stati raggiunti questi obiettivi:
- codifica della struttura di #gls("api") di #gls("backend"), dalla quale si interfaccerà il #gls("frontend")
- codifica del #emph("service") principale che orchestra la pipeline di analisi
- impostazione di interfaccia minimale per l'avvio di analisi dal web
- integrazione degli adapter per il recupero di dati reali per l'analisi (#gls("kev"), #gls("epss"), #gls("cvss"))
Per acellerare la codifica di questa parte e testare la validità degli studi fatti riguardo al dominio è stato fatto uso di #emph("fixture") di dati (risposte sintentiche delle chiamate #gls("api") dei vari servizi), in modo da strutturare la logica di #gls("backend") anche senza avere le credenziali di #gls("qualys") o #gls("claude").

=== Sesta settimana

Nella sesta settimana è stato integrato nel sistema l'#gls("AI"), tuttavia è stato necessario virare ad un modello gratuito come #emph("Gemini-Flash"), per una mancanza di credenziali di un modello a pagamento come #emph("Claude Sonnet").
L'utilizzo di un modello gratuito è stato fortemente limitante per un analisi accurata di tutte le #gls("cve") trovate dallo scanner. Per questo motivo nell'#gls("mvp") dimostrativo è stato necessario far generare una spiegazione solo alle cinque più gravi vulnerabilità del dispositivo target.
In seguito è stato anche impostato l'ambiente di test con la macchina virtuale di #gls("qualys") con utenza al #gls("tenant") #gls("cloud") per interfacciarsi alle #gls("api") di lancio analisi e recupero dati.

=== Settima settimana

Durante questa settimana è stato raffinato il recupero di informazioni tramite #gls("api"), risolvendo un problema di limiti di richieste e numero di dati richiesti.
In seguito è stato completato e stilizzato il frontend, pensato per essere piacevole e funzionale ad una figura come un analista di sicurezza, più precisamente sono state completate:
- pagina di home con lista di scansioni completate.
- pagina di lancio scansione, con #gls("pipeline") visiva per monitorare l'avanzamento del processo.
- pagina di report con una dettagliata spiegazione di come interpretare i dati forniti e una tabella dimostrativa e piacevole da consultare con funzionalità di ordinamento per campo dati selezionato.
- bottone di esportazione con annessa funzionalità di creazione report in formato #gls("docx").

=== Ottava settimana

Durante questa fase, è stato progettato e implementato un sistema di gestione delle eccezioni personalizzato e granulare, al fine di segnalare in modo preciso e completo all'utente eventuali fallimenti durante la generazione del report delle vulnerabilità. Nello specifico sono state modellate delle classi di errore dedicate, sollevate in risposta a casi di errore di #gls("api") esterne. Queste eccezioni vengono poi normalizzate in una struttura standardizzata, comprensiva di codice errore, descrizione ed altri parametri di contesto.
Questo approccio serve sia per notificare correttamente l'utente e migliorare la #emph("user experienxe"), sia per agevolare lo sviluppatore in fase di #emph[#gls("debugging")] della piattaforma.

=== Nona settimana

Nell'ultima settimana è stato raffinato il lavoro compiuto, procedendo con un'attenta fase di #gls("refactoring") del codice.
Questo intervento ha permesso di ordinare e modularizzare le funzioni presenti nella #gls("codebase"), garantendo un codice più pulito, coerente e facilmente manutenibile in vista di sviluppi futuri.
È stato infine predisposto un sito web statico per la documentazione del codice, in modo da lasciare una guida di riferimento che può essere mantenuta per agevolare l'orientamento e l'intervento di futuri sviluppatori.