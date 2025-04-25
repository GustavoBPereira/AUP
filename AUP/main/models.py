from django.db import models


class Patente(models.Model):
    nome = models.CharField(max_length=100)

    
    def __str__(self):
        return self.nome


class Funcoes(models.TextChoices):
    ENGENHEIRO = 'engenheiro', 'Engenheiro'
    PILOTO = 'piloto', 'Piloto'
    COMUNICACAO = 'comunicacao', 'Comunicação'
    ARMAS = 'armas', 'Armas'
    CIENCIAS = 'ciencias', 'Ciências'
    CAPITAO = 'capitao', 'Capitão'
    PRIMEIRO_OFICIAL = 'primeiro_oficial', 'Primeiro Oficial'
    GM = 'gm', 'GM'

class Tripulante(models.Model):
    nome = models.CharField(max_length=100)
    patente = models.ForeignKey(Patente, on_delete=models.CASCADE)
    funcao_principal = models.CharField(max_length=20, choices=Funcoes.choices)
    funcao_secundaria = models.CharField(max_length=20, choices=Funcoes.choices)
    email = models.EmailField(max_length=254, blank=True, null=True)
    telefone = models.CharField(max_length=20, blank=True, null=True)
    
    def __str__(self):
        return self.nome


class Nave(models.Model):
    nome = models.CharField(max_length=100)
    tripulante = models.ManyToManyField(Tripulante)
    
    def __str__(self):
        return self.nome


class Missao(models.Model):
    nome = models.CharField(max_length=100)
    descricao = models.TextField()
    
    def __str__(self):
        return self.nome


class Base(models.Model):
    nome = models.CharField(max_length=100)
    
    def __str__(self):
        return self.nome


class Historico(models.Model):
    data = models.DateField()
    base = models.ForeignKey(Base, on_delete=models.CASCADE)
    missao = models.ForeignKey(Missao, on_delete=models.CASCADE)
    teve_GM = models.BooleanField(default=False)
    nave = models.ForeignKey(Nave, on_delete=models.SET_NULL, null=True, blank=True)
    
    def __str__(self):
        return f"{self.missao.nome} - {self.data}"


class FuncaoExercida(models.Model):
    historico = models.ForeignKey(Historico, on_delete=models.CASCADE)
    tripulante = models.ForeignKey(Tripulante, on_delete=models.CASCADE)
    funcao = models.CharField(max_length=20, choices=Funcoes.choices)
    pontuacao = models.IntegerField()
    descricao = models.TextField()
    
    def __str__(self):
        return f"{self.tripulante.nome} - {self.funcao} - {self.historico.data}"
