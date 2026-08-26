#pagebreak(to:"odd")

#import "../config/glossario-data.typ": gls

= Ambiente di test

== Architettura del laboratorio

L'ambiente di collaudo di ThreatLens è costituito da due macchine virtuali (VM) che comunicano tra di loro tramite un'interfaccia di rete in modalità *bridge*.
La prima VM ospita uno scanner Qualys incaricato di eseguire le scansioni di vulnerabilità sulla macchina target e di inviare i risultati al tenant cloud di Qualys.
Threatlens utilizza le API proprietarie di Qualys per inviare il segnale di inizio scansione alla VM scanner e poi, sempre tramite API, rileva i risultati delle scansioni.
La seconda VM ospita Metasploitable2, una macchina Linux intenzionalmente vulnerabile, usata per condurre test per strumenti di sicurezza e praticare tecniche di #emph("pentesting") comuni.

== Problemi e soluzioni adottate

A causa dell'indisponibilità temporanea del datacenter aziendale di Kirey, l'infrastruttura di virtualizzazione è stata ospitata localmente su una workstation personale. Tale vincolo ha imposto un'allocazione stringente delle risorse hardware: 2 GB di RAM e 1 vCPU per l'istanza Metasploitable, e 4 GB di RAM e 2 vCPU per l'appliance Qualys.

Questo ridimensionamento ha inizialmente impattato i cicli di sviluppo, portando i tempi di esecuzione di una singola scansione fino a superare un'ora e mezza. Per ottimizzare il processo di sviluppo e testing della piattaforma è stata sfruttata la modularità architetturale della #gls("pipeline") di elaborazione. Tramite un branch di git dedicato è stata saltata la fase di scansione real-time ed è stata eseguita l'elaborazione dei dati da una scansione precedentemente lanciata.

Questo approccio ha permesso di snellire lo sviluppo senza compromettere l'affidabilità della piattaforma. Infatti il meccanismo di avvio della scansione era già stato testato e validato, mentre il fulcro della complessità logica risiedeva nel recupero dei dati e nel calcolo della priorità della #gls("cve").