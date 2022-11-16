# В этом каталоге сценарии для автоматизации рутинных задач vSphere
1. Get-EsxVmnicsInfo.ps1 выгружает информацию в CSV по физическим сетевым адаптерам хоста (версия драйвера, версия прошивки и т.д.)
- Запуск скрипта с указанием целевого vCenter (сохранение данных на рабочем столе):
```
.\Get-EsxVmnics.ps1 -vCenterServer <vCenter_Name>
```
- Запуск скрипта с указанием целевого vCenter и папки сохранения результатов:
```
.\Get-EsxVmnics.ps1 -vCenterServer <vCenter_Name> -Folder C:\Temp
```
2. ChangeUUID.ps1 производит замену uuid.bios на вновь сгенерированный.
- Запуск скрипта с указанием целевого vCenter (список вм должен быть в одной папке со скриптом):
```
.\ChangeUUID.ps1 -vCenterServer <vCenter_Name>
```
- Запуск скрипта с указанием целевого vCenter и пути до файла со списоком ВМ:
```
.\Get-EsxVmnics.ps1 -vCenterServer <vCenter_Name> -Path C:\Temp\ChangeUUID\vm_list.txt
```
