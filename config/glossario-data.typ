// File: config/glossario-data.typ

#let mio-glossario = (
  (
    key: "cve",
    parola: "CVE",
    desc: "Un dizionario pubblico di vulnerabilità e falle di sicurezza note.",
  ),
  (
    key: "vulnerability-assessment",
    parola: "Vulnerability Assessment",
    desc: "Processo sistematico di identificazione, quantificazione e classificazione delle vulnerabilità in un sistema.",
  ),
)

// La nostra funzione magica per stampare la parola con la G al pedice e il link
#let gls(chiave) = {
  let voce = mio-glossario.find(v => v.key == chiave)
  
  if voce != none {
    // Se trova la parola, crea il link, stampa la parola e aggiunge il pedice G
    link(label(chiave))[#voce.parola#sub[G]]
  } else {
    // Se scrivi male la chiave, te lo segnala in rosso nel PDF!
    text(fill: red)[Errore: #chiave mancante]
  }
}