---
title: "Je Laravel website deployen met 1 commando"
date: 2015-05-23T16:30:00+02:00
draft: false
summary: "Voor deze nieuwe blog wilde ik een script maken dat in 1 keer de nieuwste versie van mijn code uploadt naar mijn webserver. Dit heb ik gedaan door een nieuw commando aan Artisan -- de command-line interface van Laravel Framework -- toe te voegen."
types: ['tutorial']
subjects: ['deploy', 'devops', 'laravel']
params:
  outdated_warning: true
---
Deze website is gebouwd op Laravel Framework (nu nog versie 4.2). Met de bijgeleverde [command-line interface Artisan](http://laravel.com/docs/4.2/artisan) kun je verschillende commando's uitvoeren. Je kunt bijvoorbeeld de database-migraties uitvoeren, alle geregistreerde routes bekijken of de geïnstalleerde versie van Laravel opvragen. Ik heb daar zelf een commando aan toegevoegd dat alle stappen uitvoert om mijn code te deployen.

## Voorwaarden
Om dit commando zelf te kunnen gebruiken heb je een aantal zaken nodig:

* Je website is gebouwd op Laravel Framework versie 4.1 of hoger
* Je hebt SSH-toegang tot je webserver waarop Composer en Git zijn geïnstalleerd
* De code van je website staat op Git-repository van GitHub, BitBucket of een vergelijkbare dienst
* Je hebt de SSH-key van je server ingesteld op GitHub en/of Bitbucket en daarbij gekozen om geen wachtwoord in te stellen.

## Het commando
Het deploy-commando wordt gedefinieerd door het bestand `/app/commands/DeployCommand.php` waarvan dit de inhoud is:
```php
<?php

use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputArgument;

class DeployCommand extends Command
{
    const OBJECT_ARGUMENT_SEPARATOR = ':';

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'deploy';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'All the procedures needed for deploying the website';

    /**
     * Return the arguments for this command.
     *
     * @return array
     */
    protected function getArguments()
    {
        return [
            ['versie', InputArgument::REQUIRED, 'Versie die je wilt deployen, bijvoorbeeld v1.0.0'],
        ];
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function fire()
    {
        if (!$this->confirm('Wil je echt deployen? [yes|no]', false)) {
            $this->info('Niet gedeployed. Klaar!');

            return;
        }

        $versie = $this->argument('versie');

        $this->info('Deploy versie '.$versie);

        $this->deploy();

        $this->info('Klaar met deployen van versie '.$versie.'!');
    }

    /**
     * Deploy to the production environment using SSH.
     */
    protected function deploy()
    {
        $logfile        = 'storage/logs/'.date('YmdHis').'.log';
        $redirecttofile = ' | tee -a '.$logfile.' 2>&1';

        SSH::into('production')->run(
            [
                'php artisan down'.$redirecttofile,
                'git pull origin master '.$this->argument('versie').$redirecttofile,
            ]
        );

        SSH::put('.env.production.php', '.env.php');

        SSH::into('production')->run(
            [
                'composer install --no-dev'.$redirecttofile,
                'php artisan migrate --force'.$redirecttofile,
                'php artisan up'.$redirecttofile,
            ]
        );
    }
}
```

Om het commando te laten werken moet je nog 3 dingen instellen:
1. Registreer het commando door aan `app/start/artisan.php` de volgende regel toe te voegen:
```php
 Artisan::resolve('DeployCommand'); 
```
2. Configureer in `app/config/remote.php` de connectie die in het script gebruikt wordt om via SSH met de webserver te verbinden. Bij mij ziet die configuratie er zo uit:
```php
'connections' => [
    'production' => [
        'host'      => getenv('SSH_HOST'),
        'username'  => getenv('SSH_USERNAME'),
        'password'  => getenv('SSH_PASSWORD'),
        'key'       => '',
        'keyphrase' => '',
        'root'      => getenv('SSH_ROOT'),
    ],
],
```
waarbij de informatie uit mijn configuratiebestand wordt gehaald dat niet in Git staat. In de documentatie Laravel kun je meer lezen over het [veilig configureren van je applicatie](http://laravel.com/docs/4.2/configuration#protecting-sensitive-configuration).
3. Je moet lokaal het configuratiebestand van je live server (in mijn geval `.env.production.php`) hebben staan zodat deze kan worden geüpload naar de productieserver.

## Wat doet het?
Het lijkt me dat het grootste gedeelte van de code voor zich spreekt. Een paar dingen wil ik speciaal toelichten:
* Je roept het commando aan met een versienummer (Git tag) dat gedeployed moet worden, bijvoorbeeld <code class="language-bash">php artisan deploy v1.1.2</code>.
* De output van alle commando's die via SSH worden uitgevoerd wordt naar een logbestand geschreven én op het scherm getoond, hier zorgt het [`tee`-commando](http://en.wikipedia.org/wiki/Tee_%28command%29) voor.
* Door `php artisan migrate` met parameter `--force` aan te roepen wordt er niet om een bevestiging gevraagd.

## Meer weten?
In de documentatie van Laravel kun je meer lezen over het [ontwikkelen van commando's voor Artisan](http://laravel.com/docs/4.2/commands) en de mogelijkheden van de [SSH facade](http://laravel.com/docs/4.2/ssh). 