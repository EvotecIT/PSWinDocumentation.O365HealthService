### PSWinDocumentation.O365HealthService Release History

#### 1.0.3 - 31.01.2021
  - Brings back StartDate and EndDate for issues

#### 1.0.2 - 31.01.2022
  - Fixes cross-platform timezone issue [#10](https://github.com/EvotecIT/PSWinDocumentation.O365HealthService/issues/10) - this time for real

#### 1.0.1 - 31.01.2022
  - Fixes cross-platform timezone issue [#10](https://github.com/EvotecIT/PSWinDocumentation.O365HealthService/issues/10)

#### 1.0.0 - 29.01.2022
  - Microsoft disabled the Health Service API. Migrated code to Graph API.
  - There are **breaking changes** on the output (aka a bit differently formatted information), less types, different columns, etc.
  - Check examples for more information.
  - Permission requirements changed

![https://evotec.xyz/wp-content/uploads/2022/01/img_61f59e2b000c3.png](https://evotec.xyz/wp-content/uploads/2022/01/img_61f59e2b000c3.png)

#### 0.2.4. -13.12.2019
  - Enforces TLS 1.2 as it may be problematic otherwise. Hopefully doesn't break anything
    - Added parameter `TlsDefault` to `Get-Office365Health -TlsDefault` as a way to circumvent that new feature, just in case. Subject to removal later on
#### 0.2.3 - 7.11.2019
  - Optimized module removing depedencies (PSSharedGoods) on release
    - It's still used during development
#### 0.2.2 - 13.05.2019
  - Fix for mispelled extended word (sorry again..)
#### 0.2.1 - 08.05.2019
  - Fix for mispelled extended word (sorry)
#### 0.2.0 - 03.05.2019
  - Fix for date changes that Microsoft introduced
#### 0.1.0 - 22.04.2019
  - First public release

![Image](https://evotec.xyz/wp-content/uploads/2019/05/img_5cd34ae647da9.png)