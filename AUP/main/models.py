from django.db import models


class Patente(models.Model):
    nome = models.CharField(max_length=100)

    
    def __str__(self):
        return self.nome


class Funcoes(models.Model):
    nome = models.CharField(max_length=100)
    descricao = models.TextField()
    
    def __str__(self):
        return self.nome

class Tripulante(models.Model):
    nome = models.CharField(max_length=100)
    patente = models.ForeignKey(Patente, on_delete=models.CASCADE)
    funcao_principal = models.ForeignKey(Funcoes, related_name='funcao_principal', on_delete=models.CASCADE)
    funcao_secundaria = models.ForeignKey(Funcoes, related_name='funcao_secundaria', on_delete=models.CASCADE)
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
    funcao = models.ForeignKey(Funcoes, on_delete=models.CASCADE)
    pontuacao = models.IntegerField()
    descricao = models.TextField()
    
    def __str__(self):
        return f"{self.tripulante.nome} - {self.funcao} - {self.historico.data}"
