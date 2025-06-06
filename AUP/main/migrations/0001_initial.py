# Generated by Django 5.2 on 2025-04-25 02:07

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Base',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nome', models.CharField(max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='Missao',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nome', models.CharField(max_length=100)),
                ('descricao', models.TextField()),
            ],
        ),
        migrations.CreateModel(
            name='Nave',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nome', models.CharField(max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='Patente',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nome', models.CharField(max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='Historico',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('data', models.DateField()),
                ('teve_GM', models.BooleanField(default=False)),
                ('base', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='main.base')),
                ('missao', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='main.missao')),
                ('nave', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='main.nave')),
            ],
        ),
        migrations.CreateModel(
            name='Tripulante',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nome', models.CharField(max_length=100)),
                ('funcao_principal', models.CharField(choices=[('engenheiro', 'Engenheiro'), ('piloto', 'Piloto'), ('comunicacao', 'Comunicação'), ('armas', 'Armas'), ('ciencias', 'Ciências'), ('capitao', 'Capitão'), ('primeiro_oficial', 'Primeiro Oficial'), ('gm', 'GM')], max_length=20)),
                ('funcao_secundaria', models.CharField(choices=[('engenheiro', 'Engenheiro'), ('piloto', 'Piloto'), ('comunicacao', 'Comunicação'), ('armas', 'Armas'), ('ciencias', 'Ciências'), ('capitao', 'Capitão'), ('primeiro_oficial', 'Primeiro Oficial'), ('gm', 'GM')], max_length=20)),
                ('email', models.EmailField(blank=True, max_length=254, null=True)),
                ('telefone', models.CharField(blank=True, max_length=20, null=True)),
                ('patente', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='main.patente')),
            ],
        ),
        migrations.AddField(
            model_name='nave',
            name='tripulante',
            field=models.ManyToManyField(to='main.tripulante'),
        ),
        migrations.CreateModel(
            name='FuncaoExercida',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('funcao', models.CharField(choices=[('engenheiro', 'Engenheiro'), ('piloto', 'Piloto'), ('comunicacao', 'Comunicação'), ('armas', 'Armas'), ('ciencias', 'Ciências'), ('capitao', 'Capitão'), ('primeiro_oficial', 'Primeiro Oficial'), ('gm', 'GM')], max_length=20)),
                ('pontuacao', models.IntegerField()),
                ('descricao', models.TextField()),
                ('historico', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='main.historico')),
                ('tripulante', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='main.tripulante')),
            ],
        ),
    ]
