# exercise-3



## Процесс запуска 
* 1 вариант 
Run vagrant
запускает три локальные роли и устанавливает дополнительную  роль galaxy
```
vagrant up node22
```

* 2 вариант
Run ansible 
запускает три локалные роли

```
ansible-playbook playbooks/playbook.yml  --ask-vault-pass
```


