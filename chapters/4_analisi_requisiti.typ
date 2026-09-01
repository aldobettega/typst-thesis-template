#import "../config/thesis-config.typ": useCase
#import "../config/glossario-data.typ": gls

#pagebreak(to:"odd")

= Analisi dei Requisiti

A seguito dello studio del dominio del problema, si è proceduto alla definizione dei casi d'uso e alla conseguente stesura dei requisiti di sistema.

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
  "Flusso principale": [L'utente seleziona lo scanner da utilizzare per l'analisi. Attualmente il sistema vincola la selezione all'unica opzione supportata (#gls("qualys")).]
))

#v(1em)

#useCase((
  number: "1.2",
  name: [Inserimento #gls("ip") target],
  "Attore principale": "Utente",
  "Flusso principale": [L'utente inserisce un singolo indirizzo #gls("ip") che rappresenta il target su cui effettuare l'analisi delle vulnerabilità.]
))

#v(1em)

#useCase((
  number: "1.3",
  name: [Definizione dell'#gls("asset context")],
  "Attore principale": "Utente",
  "Flusso principale": [L'utente seleziona i tre parametri di contesto necessari a delineare il profilo di rischio del target: ambiente (#emph("environment")), esposizione (#emph("exposure")) e criticità (#emph("criticality")).]
))

#v(1em)

#useCase((
  number: "2",
  name: "Monitoraggio dell'avanzamento dell'analisi",
  "Attore principale": "Utente",
  "Flusso principale": [L'utente visualizza l'interfaccia dedicata allo stato dell'analisi. Il sistema interroga lo scanner e mostra in tempo reale l'avanzamento del processo (scansione in corso, recupero di dati, generazione #gls("AI") o #gls("pipeline") fallita).],
  "Postcondizione": "L'utente è costantemente informato sullo stato di completamento del task."
))

#v(1em)

#useCase((
  number: "3",
  name: "Apertura e consultazione del report di vulnerabilità",
  "Attore principale": "Utente",
  "Precondizione": "L'utente richiede l'accesso ai risultati di una specifica analisi.",
  "Flusso principale": [Il sistema recupera il report e presenta un #emph("Vulnerability Report") aggregato che include le vulnerabilità, la loro priorità operativa e la spiegazione generata dall'#gls("AI").],
  "Sottocasi inclusi": "UC3.1 (Report non disponibile)",
  "Postcondizione": "L'utente dispone delle metriche contestuali per prendere una decisione operativa sulle remediation."
))

#v(1em)

#useCase((
  number: "3.1",
  name: "Report non disponibile",
  "Attore principale": "Utente",
  "Flusso principale": [Qualora l'analisi non sia ancora terminata, sia fallita durante la #gls("pipeline") o il report richiesto non esista nel sistema, viene mostrato un avviso a schermo che comunica esplicitamente che il report non è disponibile.],
  "Postcondizione": "L'utente è informato dell'indisponibilità del dato."
))

#v(1em)

#useCase((
  number: "4",
  name: "Esportazione del report",
  "Attore principale": "Utente",
  "Precondizione": "L'utente sta visualizzando un report completato e accessibile.",
  "Flusso principale": [L'utente richiede l'esportazione del report. Il sistema compila un documento in formato #gls("docx") contenente il dettaglio tecnico delle vulnerabilità e lo rende disponibile per il download.],
  "Sottocasi inclusi": "UC4.1 (Fallimento esportazione)",
  "Postcondizione": [Viene scaricato il file #gls("docx") del report.]
))

#v(1em)

#useCase((
  number: "4.1",
  name: "Fallimento esportazione del report",
  "Attore principale": "Utente",
  "Flusso principale": [Se il processo di compilazione del file #gls("docx") o il suo salvataggio incontrano un'eccezione, il sistema interrompe il processo di esportazione e notifica l'errore all'utente tramite un apposito messaggio.],
  "Postcondizione": "Il sistema segnala il fallimento dell'operazione e l'esportazione viene annullata."
))

#v(1em)

#useCase((
  number: "5",
  name: "Invio del report tramite email",
  "Attore principale": "Utente",
  "Flusso principale": [L'utente, dopo aver visualizzato un'analisi completata, richiede l'invio del report tramite email e specifica l'indirizzo di destinazione. Il sistema predispone il documento (es. in formato #gls("docx")), lo allega a un messaggio e lo inoltra al server SMTP per la consegna.],
  "Postcondizione": "Il report viene inviato con successo all'indirizzo specificato e il sistema conferma all'utente la presa in carico dell'operazione."
))

#v(1em)

#useCase((
  number: "5.1",
  name: "Fallimento invio del report tramite email",
  "Attore principale": "Utente",
  "Flusso principale": [Se il sistema rileva un errore durante la comunicazione con il server di posta (ad esempio per problemi di rete, timeout o credenziali non valide) o se l'indirizzo email fornito risulta malformato, il processo di invio viene interrotto.],
  "Postcondizione": "L'email non viene inoltrata e il sistema notifica l'utente dell'errore, invitandolo a riprovare o a controllare i dati inseriti."
))

== Requisiti Funzionali

Nella seguente tabella sono riportati i requisiti funzionali obbligatori estratti dai casi d'uso.

#show table.cell.where(y: 0): set text(weight: "bold")

#table(
  // Definiamo 3 colonne: Codice stretto, Descrizione espansa, Fonti stretta
  columns: (auto, 1fr, auto),
  
  // Allineiamo il testo: centrato per i codici e le fonti, a sinistra per la descrizione
  align: (col, row) => if col == 1 { left } else { center + horizon },
  
  // Colore di sfondo per la prima riga (simile allo screenshot)
  fill: (col, row) => if row == 0 { rgb("539b98") } else { none },
  
  // Bordo tabella
  stroke: 0.5pt + black,
  
  // Intestazione
  [Codice], [Descrizione], [Fonti],

  // Righe
  [RF001], [Il sistema deve permettere all'Utente di richiedere l'avvio di una nuova analisi.], [UC1],
  
  [RF002], [L'Utente deve poter selezionare lo scanner dall'interfaccia. Il sistema deve forzare l'unica opzione supportata (#gls("qualys")).], [UC1.1],
  
  [RF003], [L'Utente deve poter inserire un singolo indirizzo #gls("ip") in un apposito campo di testo.], [UC1.2],
  
  [RF004], [L'Utente deve poter selezionare i parametri dell'#gls("asset context") (ambiente, esposizione e criticità) attraverso appositi menu a tendina o selettori.], [UC1.3],
  
  [RF005], [Il sistema deve mostrare all'Utente un indicatore visivo in tempo reale con lo stato esatto della scansione (es. in corso, recupero dati, AI, fallita).], [UC2],
  
  [RF006], [Il sistema deve renderizzare a schermo il Vulnerability Report, mostrando le vulnerabilità, il badge della priorità operativa calcolata e il testo dell'#gls("AI").], [UC3],
  
  [RF007], [Il sistema deve mostrare all'Utente un avviso di Report non disponibile se si tenta di aprire un'analisi inesistente, ancora in esecuzione o fallita.], [UC3.1],
  
  [RF008], [L'Utente deve poter cliccare un comando specifico per richiedere la compilazione e il download del report in formato #gls("docx").], [UC4],
  
  [RF009], [Il sistema deve intercettare gli errori di generazione file e notificare l'Utente con un messaggio d'errore a schermo.], [UC4.1]
)