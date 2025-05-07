from django.contrib import admin
from .models import Patente, Tripulante, Nave, Missao, Base, Historico, FuncaoExercida, Funcoes

class PatenteAdmin(admin.ModelAdmin):
    list_display = ('nome',)
    search_fields = ('nome',)

class TripulanteAdmin(admin.ModelAdmin):
    list_display = ('nome', 'patente', 'funcao_principal', 'funcao_secundaria')
    list_filter = ('patente', 'funcao_principal', 'funcao_secundaria')
    search_fields = ('nome',)

class NaveAdmin(admin.ModelAdmin):
    list_display = ('nome',)
    filter_horizontal = ('tripulante',)
    search_fields = ('nome',)

class MissaoAdmin(admin.ModelAdmin):
    list_display = ('nome', 'descricao')
    search_fields = ('nome', 'descricao')

class BaseAdmin(admin.ModelAdmin):
    list_display = ('nome',)
    search_fields = ('nome',)

class HistoricoAdmin(admin.ModelAdmin):
    list_display = ('missao', 'data', 'base', 'teve_GM')
    list_filter = ('base', 'teve_GM', 'data')
    date_hierarchy = 'data'
    search_fields = ('missao__nome',)

class FuncaoExercidaAdmin(admin.ModelAdmin):
    list_display = ('tripulante', 'funcao', 'historico', 'pontuacao')
    list_filter = ('funcao', 'pontuacao')
    search_fields = ('tripulante__nome', 'descricao')

class FuncoesAdmin(admin.ModelAdmin):
    list_display = ('nome',)
    search_fields = ('nome',)


admin.site.register(Patente, PatenteAdmin)
admin.site.register(Tripulante, TripulanteAdmin)
admin.site.register(Nave, NaveAdmin)
admin.site.register(Missao, MissaoAdmin)
admin.site.register(Base, BaseAdmin)
admin.site.register(Historico, HistoricoAdmin)
admin.site.register(FuncaoExercida, FuncaoExercidaAdmin)
admin.site.register(Funcoes, FuncoesAdmin)