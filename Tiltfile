if not (k8s_context() == 'microk8s' or k8s_context() == 'docker-desktop'):
  fail('\n\nYou must be in the "microk8s" or "docker-desktop" k8s context.\nSet it via "kubectl config set-context <desired context>" and try again\n')

disable_snapshots()

main_interpolated_yaml = local(r'cat tilt/configs/deployment.yaml.template | sed "s|__HOME__|${HOME}|"', quiet=True)
watch_file('./tilt/configs/deployment.yaml.template')

k8s_yaml(main_interpolated_yaml)
k8s_yaml('./tilt/configs/db-deployment.yaml')

jfrog_creds = local(r'./../ez-rails/tilt/scripts/artifactory_setup_for_tilt', quiet=True)
build_args = {
  'BUNDLE_EZCATER__JFROG__IO': ('%s' % jfrog_creds)
}

docker_build('localhost:32000/schema-registry-web:registry', '.',
  build_args=build_args,
  live_update=[
    sync('.', '/usr/src/app')
  ]
)

k8s_resource('schema-registry-web', port_forwards='21004', resource_deps=['schema-registry-db'])
k8s_resource('schema-registry-db', port_forwards='26436')
