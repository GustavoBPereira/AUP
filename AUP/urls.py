from django.contrib import admin
from django.urls import path
from django.conf import settings
from django.conf.urls.static import static
from AUP.main import views
from django.urls import re_path
from django.views.static import serve


urlpatterns = [
    path('admin/', admin.site.urls),
    path('', views.home, name='home'),
    path('tripulacao/', views.tripulacao, name='tripulacao'),
    path('canony/', views.canony, name='canony'),
    path('historico-missoes/', views.historico_missoes, name='historico_missoes'),
    path('patentes/', views.patentes, name='patentes'),
    path('eventos/', views.eventos, name='eventos'),
    path('monte-base/', views.monte_base, name='monte_base'),
    re_path(r'^static/(?P<path>.*)$', serve, {'document_root': settings.STATIC_ROOT}),

]
