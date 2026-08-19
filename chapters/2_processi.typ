#pagebreak(to:"odd")

= Processi e metodologie

In questo capitolo viene riportato il modo in cui mi sono interfacciato con i miei tutor e come abbiamo organizzato il lavoro fissando i vari obiettivi lungo il corso del progetto.

== Metodologia di lavoro

Durante le prime settimane l'attività si è svolta in modalità ibrida, per poi passare a un regime completamente da remoto a causa dell'inagibilità della sede aziendale. Sebbene la modalità a distanza sia stata preponderante, l'efficienza operativa e la collaborazione non ne hanno risentito. L'uso di canali di comunicazione sincroni e asincroni ha infatti garantito un aggiornamento continuo sull'avanzamento delle attività e un supporto continuo in caso di difficoltà.

Quotidianamente erano previste una o due riunioni di allineamento per monitorare i progressi e affrontare le eventuali problematiche emerse. Infine, ogni venerdì mattina si teneva una sessione di revisione più formale, dedicata alla presentazione dei risultati settimanali, all'analisi della direzione del progetto e alla discussione di eventuali proposte o azioni correttive.

== Pianificazione delle attività

L'organizzazione delle attività è stata calcolata in divenire, in modo da allocare correttamente le risorse disponibili ed avere sotto controllo il raggiungimento degli obiettivi restando entro il tempo prestabilito dal tirocinio.
In autonomia ho stilato un calendario settimanale su *Notion*, dove tenevo traccia degli obiettivi giornalieri. 
Questo strumento mi ha permesso di monitorare efficacemente lo stato di avanzamento, offrendomi la flessibilità di riprogrammare i task rivelatisi più complessi o di anticipare le attività successive in caso di completamento anticipato del carico giornaliero.

Questo programma veniva poi condiviso a fine settimana per mostrare il progresso raggiunto e condividere le attività che erano state più onerose, al fine di chiedere un consiglio ai colleghi più esperti per le problematiche ancora aperte.

- *Prima*: è stato fatto uno studio approfondito delle tecnologie che sono state usate nel progetto, in particolare il framework di angular, con esercizi, tutorial e progetti didattici orientati alle parti del framework che avrei dovuto usare per sviluppare la piattaforma.

- *Seconda settimana*: è stato affrontato il dominio del problema: sono stati studiati i concetti di cve e che cosa sia uno scanner. Questo studio è stato integrato dalla lettura di articoli scientifici inerenti alle tematiche del *vulnerability assessment* e della prioritizzazione del rischio.


- *Terza settimana*: è stata fatta un'analisi dei requisiti della piattaforma, delineando le principali funzionalità dell'applicazione e la sua interfaccia. Inoltre è stata iniziata la progettazione del sistema, definendo le classi di backend e le componenti angular con le loro principali funzioni. In aggiunta è stata progettata l'organizzazione della repo e dei suoi file, in modo da poter procedere con uno sviluppo il quanto più possibile ordinato ed efficiente.

- *Quarta settimana*: è continuato lo studio delle tecnologie al fine di comprendere i pattern di organizzazione del codice di angular e FastAPI, in modo da utilizzarle nello sviluppo della piattaforma rispettando la progettazione architetturale.

- *Quinta settimana*: è cominciata la codifica del prodotto partendo dalle funzionalità di backend. Si è sviluppato in modo progressivo integrando man mano le parti che contribuissero al sistema di calcolo delle priorità, questa modularità ha facilitato la scrittura dei test e produrre risultati parziali ma concreti durante tutto il ciclo di implementazione.

- *Sesta e settima settimana*: è stato creato l'ambiente di test delle macchine virtuali ed è stato integrato lo scanner Qualys nel sistema e l'utilizzo dell'AI per la generazione delle spiegazioni relative alle vulnerabilità.

- *Ottava e nona settimana*: sono state dedicate al _*refactoring*_ del codice, rendendo più coerente la _*codebase*_. È stata implementata gestione degli errori personalizzata e granulare, al fine di segnalare in modo preciso e completo all'utente quale parte avesse fallito durante la produzione del report delle vulnerabilità.