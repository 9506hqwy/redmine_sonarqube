function toggleSonarQubeProjectCheckbox(e) {
    const projectId = e.target.id.slice('toggle-'.length);
    const project = document.getElementById(projectId);

    const monitoringList = document.getElementById('monitoring-project-list');
    const monitotingProject = monitoringList.querySelector(`#enable-${projectId}`);
    if (monitotingProject == null) {
        const box = document.createElement('input');
        box.type = 'checkbox';
        box.id = `enable-${projectId}`;
        box.name = 'monitoring_projects[]';
        box.value = project.dataset.projectKey;
        box.checked = true;

        monitoringList.appendChild(box);
    } else {
        monitotingProject.checked = e.target.checked;
    }
}

function toggleSonarQubeServer(target) {
    for (const field of document.getElementById('sonarqube-server-fields').querySelectorAll('input')) {
        if (field.id != 'sonarqube-enable') {
            field.disabled = !target.checked;
        }
    }

    const enableServerToken = document.getElementById('sonarqube-enable-token');
    toggleSonarQubeServerToken(enableServerToken);
}

function toggleSonarQubeServerToken(target) {
    const token = document.getElementById('sonarqube-server-fields').querySelector('input[name="password"]');
    token.disabled = target.disabled || !target.checked;
}
