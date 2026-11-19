# MCG_PHC

Código de programação usado no PHC do Grupo MCG.

## Estrutura

- `SQL SERVER/` — scripts T-SQL (views, procedures, funções, queries)
- `Visual FoxPro/` — código VFP (eventos, ecrãs, análises, rotinas internas do PHC)
- `databases.json` — registo das bases de dados PHC existentes no servidor

## Acesso ao SQL Server

As credenciais ficam no ficheiro `.env` (fora do git). Usar o `.env.example` como modelo:

```
cp .env.example .env
```

O `.env` define apenas o servidor e as credenciais. As bases de dados estão registadas em `databases.json`:

| Base de dados    | Descrição       |
|------------------|-----------------|
| `sisPHCMeivcore` | PHC – Meivcore  |
| `RHPondus`       | PHC RH – Pondus |

Para acrescentar uma nova BD, adicionar uma entrada em `databases.json` (e nesta tabela).
