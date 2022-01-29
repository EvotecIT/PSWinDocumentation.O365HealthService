Add-Type -TypeDefinition @"
    using System;

    namespace PSWinDocumentation
    {
        [Flags]
        public enum Office365Health {
            All,
            Services,
            CurrentStatus,
            CurrentStatusExtended,
            MessageCenterInformation,
            MessageCenterInformationExtended,
            Incidents,
            IncidentsExtended,
            IncidentsUpdates
        }
    }
"@