Add-Type -TypeDefinition @"
    using System;

    namespace PSWinDocumentation
    {
        [Flags]
        public enum Office365Health {
            All,
            Services,
            ServicesExteneded,
            CurrentStatus,
            CurrentStatusExteneded,
            HistoricalStatus,
            HistoricalStatusExteneded,
            MessageCenterInformation,
            MessageCenterInformationExtended,
            Incidents,
            IncidentsExteneded,
            PlannedMaintenance,
            PlannedMaintenanceExteneded,
            Messages
        }
    }
"@