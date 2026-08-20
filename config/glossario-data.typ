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