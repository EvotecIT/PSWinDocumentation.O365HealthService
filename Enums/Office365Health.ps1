Add-Type -TypeDefinition @"
    using System;

    namespace PSWinDocumentation
    {
        [Flags]
        public enum Office365Health {
            All,
            Services,
            ServicesExtended,
            CurrentStatus,
            CurrentStatusExtended,
            HistoricalStatus,
            HistoricalStatusExtended,
            MessageCenterInformation,
            MessageCenterInformationExtended,
            Incidents,
            IncidentsExtended,
            PlannedMaintenance,
            PlannedMaintenanceExtended,
            Messages
        }
    }
"@