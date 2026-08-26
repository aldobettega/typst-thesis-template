#let mio-glossario = (
  (
    key: "cve",
    parola: "CVE",
    desc: "Le Common Vulnerabilities and Exposures sono un dizionario pubblico di vulnerabilità e falle di sicurezza note.",
  ),
  (
    key: "vulnerability-assessment",
    parola: "Vulnerability Assessment",
    desc: "Processo sistematico di identificazione, quantificazione e classificazione delle vulnerabilità in un sistema.",
  ),
  (
    key: "cpe",
    parola: "CPE",
    desc: "Le Common Platform Enumeration sono stringhe standardizzate utilizzae per identificare in modo univoco hardware, software e sistemi operativi all’interno di un’infrastrutttura",
  ),
  (
    key: "ctem",
    parola: "CTEM",
    desc: "Il Continuous Threat Exposure Management è un framework di cybersecurity secondo il quale non basta solo scoprire e ordinare le vulnerabilità, ma bisogna continuamente identificare, prioritizzare e validare in base al rischio reale e al contesto di business. Questo è un processo continuo di scoping, discovery, prioritization, validation e mobilization.",
  ),
  (
    key: "vulnerability-fatigue",
    parola: "Vulneravibity Fatigue / Alert Fatigue",
    desc: "Stato di esaurimento mentale e disimpegno psicologico che colpisce gli operatori della sicurezza informatica e gli sviluppatori, derivante dall'essere sommersi da un volume eccessivo di vulnerabilità e alert. Questo fenomeno porta a una desensibilizzazione verso i rischi reali, poiché la difficoltà di gestire tutte le minacce individuate porta a ignorare o rimandare indefinitamente la risoluzione delle falle, aumentando la superficie di attacco aziendale.",
  ),
  (
    key: "remediation",
    parola: "remediation",
    desc: "Fase operativa e strutturata dedicata alla correzione definitiva delle vulnerabilità identificate durante la scansione. ",
  ),
  (
    key: "qualys",
    parola: "Qualys",
    desc: "Piattaforma enterprise utilizzata per il Vulnerability Management, permette alle aziende di identificare, classificare e monitorare le falle di sicurezza all'interno di prodotti IT.",
  ),
  (
    key: "patch",
    parola: "patch",
    desc: "Piccolo pezzo di codice o un file eseguibile progettato per aggiornare, correggere o migliorare un programma, un sistema operativo o il firmware.",
  ),
  (
    key: "patching",
    parola: "patching",
    desc: "Processo di risoluzione di un problema in modo reattivo.",
  ),
  (
    key: "teams",
    parola: "Teams",
    desc: "Piattaforma Microsoft di comunicazione e collaborazione unificata che combina chat di lavoro persistente, teleconferenza e condivisione di contenuti ",
  ),
  (
    key: "notion",
    parola: "Notion",
    desc: "Applicazione web di produttività e gestione degli appunti, sviluppata da Notion Labs Inc. Lanciata nel 2016, Notion offre funzionalità per la creazione e l'organizzazione di note, documenti, database, bacheche Kanban e molto altro.",
  ),
  (
    key: "angular",
    parola: "Angular",
    desc: "Framework open-source multipiattaforma sviluppato e mantenuto da Google (insieme a una community globale) per costruire applicazioni web dinamiche, scalabili e manutenibili, basate principalmente su TypeScript",
  ),
  (
    key: "backend",
    parola: "backend",
    desc: "Parte di un'applicazione o di un sito web che gestisce la logica di business, il database e altre operazioni invisibili all'utente finale.",
  ),
  (
    key: "fastapi",
    parola: "FastApi",
    desc: "Moderno framework web per Python utilizzato per costruire API ad alte prestazioni.",
  ),
  (
    key: "refactoring",
    parola: "refacoring",
    desc: "Il refactoring è una tecnica di ingegneria del software che consiste nella ristrutturazione della struttura interna del codice sorgente con l'obiettivo principale di migliorare la leggibilità, la manutenibilità e l'efficienza del codice, rendendolo più pulito e facile da comprendere per gli sviluppatori.",
  ),
  (
    key: "codebase",
    parola: "codebase",
    desc: "Il termine codebase, o code base, è usato nello sviluppo del software per indicare l'intera collezione di codice sorgente usata per costruire una particolare applicazione o un particolare componente",
  ),
  (
    key: "pipeline",
    parola: "pipeline",
    desc: "Catena di trasformazioni automatizzate che gestisce il ciclo di vita del software o un flusso dei dati",
  ),
  (
    key: "AI",
    parola: "AI",
    desc: [#emph("Artificial Intelligence") - sistema automatizzato, dotato di un certo grado di autonomia, progettato per operare in vista di obiettivi espliciti o impliciti, capace di generare, a partire dai dati in input, risultati sotto forma di previsioni, contenuti, raccomandazioni o decisioni, influenzando ambienti reali o virtuali. Nel presente testo, il termine è usato in senso estensivo per indicare l’impiego di modelli LLM come Gemini Flash nella generazione di contenuti testuali a partire da dati in input.],
  ),
  (
    key: "ip",
    parola: "IP",
    desc: [#emph("Internet Protocol") - identificativo di un dispositivo all'interno di una rete.],
  ),
  (
    key: "asset context",
    parola: "asset context",
    desc: "Insieme di parametri (quali ambiente, esposizione e criticità) che definiscono il profilo di rischio di un asset informatico. Consente di contestualizzare le vulnerabilità rilevate valutandone il potenziale impatto operativo reale.",
  ),
  (
    key: "scanner",
    parola: "scanner",
    desc: [termine che indica scanner di vulnerabilità (come qualys) che consentono di rilevare le CVE associate alle CPE di un dispositivo],
  ),
  (
    key: "docx",
    parola: "DOCX",
    desc: "formato di file predefinito per Microsoft Word, utilizzato per archiviare documenti di elaborazione testi contenenti testo formattato, immagini, tabelle e altri elementi multimediali.",
  ),
  (
    key: "sdk",
    parola: "SDK",
    desc: [#emph("Software Development Kit") - indica genericamente un insieme di strumenti per lo sviluppo],
  ),
  (
    key: "core",
    parola: "core",
    desc: "Parte interna dell'architettura esagonale, include dominio, service e porte di inbound ed outbound per interfacciarsi con le tecnologie esterne.",
  ),
  (
    key: "cvss",
    parola: "CVSS",
    desc: [#emph("Common Vulnerability Scoring System") - standard sviluppato da FIRTS per valutare la gravità delle vulnerabilità di sicurezza, assegnando un punteggio da 0,0 a 10,0.],
  ),
    (
    key: "triage",
    parola: "triage",
    desc: "Nel campo del vulnerability assessment indica il processo di classificazione di vulnerabilità in classi di emergenza crescenti in base alla loro gravità",
  ),
  (
    key: "epss",
    parola: "EPSS",
    desc: [#emph("Exploit Prediction Scoring System"), gestito da FIRST, stima la probabilità che una CVE venga sfruttata nei successivi 30 giorni.],
  ),
  (
    key: "kev",
    parola: "KEV",
    desc: "Il CISA KEV è un catalogo di vulnerabilità note già sfruttate attivamente, indicando se l’exploit scoperto è già stato sfruttato.",
  ),
)

/*
  (
    key: "",
    parola: "",
    desc: "",
  ),
*/

#let gls(chiave) = {
  let voce = mio-glossario.find(v => v.key == chiave)
  
  if voce != none {
    link(label(chiave))[#voce.parola#sub[G]]
  } else {
    text(fill: red)[Errore: #chiave mancante]
  }
}